//
//  LoginViewModel.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/24.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import Alamofire
import SwiftyJSON

class LoginViewModel {
    
    let phoneNumber = Observable<String?>("")
    let isLoading = Observable<Bool>(false)
    
    var isValid: SafeSignal<Bool>{
        return combineLatest(isLoading, phoneNumber) {isLoading, phoneNumber in
            return !isLoading && phoneNumber != ""
        }
    }
    
    let alertMessages = PublishSubject<String, NoError>()
    
    func login() {
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
        return [ "phoneNumber": registeredPhoneNumber ]
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
