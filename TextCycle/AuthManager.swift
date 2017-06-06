//
//  AuthManager.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/24.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import RxSwift

enum AuthenticationStatus {
    case none
    case error
    case ok
}

class AuthManager {
    
    let status = Variable(AuthenticationStatus.none)
}
