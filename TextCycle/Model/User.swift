//
//  User.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/27.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    
    let id: String!
    let username: String!
    let phoneNumber: String!
    let major: Int64
    let degree: Int64
    let year: Int64
    let sex: Int64
    let introduction: String!
    
    init(id: String, username: String, phoneNumber: String, major: Int64, degree: Int64, year: Int64, sex: Int64, introduction: String) {
        self.id = id
        self.username = username
        self.phoneNumber = phoneNumber
        self.major = major
        self.degree = degree
        self.year = year
        self.sex = sex
        self.introduction = introduction
    }
    
    static func fromJSON(_ json:JSON) -> User {
        let id = json["_id"].stringValue
        let username = json["username"].stringValue
        let phoneNumber = json["phoneNumber"].stringValue
        let major = json["major"].int64Value
        let degree  = json["degree"].int64Value
        let year = json["year"].int64Value
        let sex = json["sex"].int64Value
        let introduction = json["introduction"].stringValue

        return User(id: id, username: username, phoneNumber: phoneNumber, major: major, degree: degree, year: year, sex: sex, introduction: introduction)
    }
}
