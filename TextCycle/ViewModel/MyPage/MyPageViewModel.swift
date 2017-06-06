//
//  MyPageViewModel.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/31.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import Alamofire
import SwiftyJSON

class MyPageViewModel {
    
    let myPosts = MutableObservableArray<Post>([])
    
    let isLoading = Observable<Bool>(false)
    
    let alertMessages = PublishSubject<String, NoError>()
    
    init() {
        setupPosts()
    }
    
    private func setupPosts() {
        isLoading.value = true
        if let id = ud.object(forKey: "id") as? String {
            Alamofire.request(PostRouter.fetchPrivatePost(user_id: id)).responseJSON { [unowned self] response in
                switch response.result {
                case .success:
                    self.myPosts.removeAll()
                    let json = JSON(response.data)
                    for (_, json) in json {
                        let post = Post.fromJSON(json)
                        self.myPosts.append(post)
                    }
                case .failure(let error):
                    self.alertMessages.next(error.localizedDescription)
                }
            }
        }
        isLoading.value = false
    }
    
}
