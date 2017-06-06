//
//  ModifyProfileViewModel.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/06/01.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import Alamofire
import SwiftyJSON

class ModifyProfileViewModel {
    
    let username = Observable<String?>("")
    let degree = Observable<Degree!>(nil)
    let year = Observable<Year!>(nil)
    let sex = Observable<Sex!>(nil)
    let introduction = Observable<String?>("")
    
    let isLoading = Observable<Bool>(false)
    
    let alertMessages = PublishSubject<String, NoError>()
    
    init() {
        username.value = ud.object(forKey: "Username") as! String
        degree.value = Degree(rawValue: ud.object(forKey: "Degree") as! Int)
        year.value = Year(rawValue: ud.object(forKey: "Year") as! Int)
        sex.value = Sex(rawValue: ud.object(forKey: "Sex") as! Int)
        introduction.value = ud.object(forKey: "Introduction") as! String
    }
    
    func modifyUser() {
        isLoading.value = true
        let parameters = convertParameters()
        Alamofire.request(UserRouter.updateUser(id: ud.object(forKey: "id") as! String as! String, parameters: parameters)).responseString { [unowned self] response in
            switch response.result {
            case .success:
                self.alertMessages.next("変更しました")
            case .failure(let error):
                self.alertMessages.next(error.localizedDescription)
            }
        }
        isLoading.value = false
    }
    
    private func convertParameters() -> Parameters {
        var intro = "よろしくお願いします"
        if let text = introduction.value {
            intro = text
        }
        let parameters: Parameters = [
            "degree": degree.value.rawValue,
            "year": year.value.rawValue,
            "sex": sex.value.rawValue,
            "introduction": intro
        ]
        return parameters
    }
 
}
