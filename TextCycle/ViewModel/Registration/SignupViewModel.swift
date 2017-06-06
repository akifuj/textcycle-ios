//
//  SignupViewModel.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/29.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import DigitsKit
import Alamofire
import SwiftyJSON

class SignupViewModel {
    
    let username = Observable<String?>("")
    let major = Observable<Major>(.Commerce)
    let degree = Observable<Degree>(.Bachelor)
    let year = Observable<Year>(.First)
    let sex = Observable<Sex>(.None)
    let phoneNumber = Observable<String?>("")
    let isDigitsLoading = Observable<Bool>(false)
    let introduction = Observable<String?>("")
    let isLoading = Observable<Bool>(false)
    
    var isValid: SafeSignal<Bool>{
        return combineLatest(isLoading, username, phoneNumber) { isLoading, username, phoneNumber in
            return !isLoading && username != "" && phoneNumber != ""
        }
    }
    
    let alertMessages = PublishSubject<String, NoError>()
    
    func checkSignupBefore() {
        let digits = Digits.sharedInstance()
        if let phoneNum = digits.session()?.phoneNumber {
            phoneNumber.value = phoneNum
            alertMessages.next("既にこの端末は登録されております")
        }
    }
    
    func confirmPhoneNumber() {
        isDigitsLoading.value = true
        let digits = Digits.sharedInstance()
        let configuration = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask)
        configuration?.appearance = DGTAppearance()
        configuration?.appearance.backgroundColor = UIColor.white
        configuration?.appearance.accentColor = UIColor(red: 0, green: 219 / 255.0, blue: 118 / 255.0, alpha: 1)
        configuration?.phoneNumber = "+81"
        digits.authenticate(with: nil, configuration: configuration!) {[unowned self] (session, error) in
            if (error == nil) {
                self.phoneNumber.value = session?.phoneNumber!
            } else {
                self.alertMessages.next((error?.localizedDescription)!)
            }
        }
        isDigitsLoading.value = false
    }
    
    func signup() {
        isLoading.value = true
        let parameters = convertParameters()
        Alamofire.request(UserRouter.createUser(parameters: parameters)).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                let json = JSON(response.data)
                self.saveToUserDefaults(user: json)
                registered.value = true
            case .failure(let error):
                self.alertMessages.next(error.localizedDescription)
            }
        }
        isLoading.value = false
    }
    
    private func convertParameters() -> Parameters {
        var telNumber = phoneNumber.value!
        let startIndex = telNumber.index(telNumber.startIndex, offsetBy: 0)
        telNumber.remove(at: startIndex)
        let registeredPhoneNumber = "+81" + telNumber
        
        var intro = "よろしくお願いします"
        if let text = introduction.value {
            intro = text
        }
        
        return [
            "username": username.value,
            "phoneNumber": registeredPhoneNumber,
            "major": major.value.rawValue,
            "degree": degree.value.rawValue,
            "year": year.value.rawValue,
            "sex": sex.value.rawValue,
            "introduction": intro
        ]
    }
    
    private func saveToUserDefaults(user: JSON) {
        ud.set(user["_id"].stringValue, forKey: "id")
        ud.set(user["username"].stringValue, forKey: "Username")
        ud.set(user["phoneNumber"].stringValue, forKey: "PhoneNumber")
        ud.set(user["major"].intValue, forKey: "Major")
        ud.set(user["degree"].intValue, forKey: "Degree")
        ud.set(user["year"].intValue, forKey: "Year")
        ud.set(user["sex"].intValue, forKey: "Sex")
        ud.set(user["introduction"].stringValue, forKey: "Introduction")
    }

}
