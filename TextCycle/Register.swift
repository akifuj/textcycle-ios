//
//  UserInfo.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/06/01.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

let registered = Observable<Bool>(true)
let ud = UserDefaults.standard

func toSignup(on vc: UIViewController) {
    let alertController = UIAlertController(title: "ログインが必要です", message: nil, preferredStyle: .alert)
    let yesAction = UIAlertAction(title: "する", style: .default) { [unowned vc] (action: UIAlertAction) in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialNav = storyboard.instantiateViewController(withIdentifier: "InitialNav")
        initialNav.modalTransitionStyle = .crossDissolve
        vc.present(initialNav, animated: true, completion: nil)
    }
    let noAction = UIAlertAction(title: "いいえ", style: .cancel)
    alertController.addAction(noAction)
    alertController.addAction(yesAction)
    vc.present(alertController, animated: true, completion: nil)
}


