//
//  SinglePostVIewModel.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/28.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import Alamofire
import SwiftyJSON
import MessageUI

class SinglePostViewModel: NSObject, MFMessageComposeViewControllerDelegate {
    
    let post: Post
    var user = Observable<User?>(nil)
    
    let isLoading = Observable<Bool>(false)
    
    let alertMessages = PublishSubject<String, NoError>()
    
    init(post: Post) {
        self.post = post
        super.init()
        fetchUser(with: post.user_id)
    }
    
    private func fetchUser(with id: String) {
        isLoading.value = true
        Alamofire.request(UserRouter.fetchUser(id: id)).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                let json = JSON(response.data)
                self.user.value = User.fromJSON(json)
            case .failure(let error):
                self.alertMessages.next(error.localizedDescription)
            }
        }
        isLoading.value = false
    }
    
    func setMessageVC() -> MFMessageComposeViewController {
        let messageVC = MFMessageComposeViewController()
        messageVC.messageComposeDelegate = self
        messageVC.recipients = [(user.value?.phoneNumber)!]
        messageVC.body = "こんにちは！ TextCycleに出品していた『\(post.title!)』を買いたいです。ご都合の良い日時と取引を行う場所を教えて下さい。"
        return messageVC
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled: controller.dismiss(animated: true, completion: {self.alertMessages.next("連絡を中止しました")})
        case .failed: controller.dismiss(animated: true, completion: {self.alertMessages.next("メッセージを送れませんでした")})
        case .sent:
            controller.dismiss(animated: true, completion: {self.alertMessages.next("メッセージを送りました"); self.updatePost()})
        }
    }
    
    private func updatePost() {
        isLoading.value = true
        let parameters = [  "buyer_id": ud.object(forKey: "id") ]
        Alamofire.request(PostRouter.updatePost(id: post.id, parameters: parameters)).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                return
            case .failure(let error):
                return  //report error
            }
        }
        isLoading.value = false
    }
}
