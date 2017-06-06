//
//  ModifyViewModel.swift
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

class ModifyPostViewModel {
    let post: Post
    
    let title = Observable<String?>("")
    let category = Observable<Category?>(nil)
    let condition = Observable<Condition?>(nil)
    let price = Observable<String?>(nil)
    
    let isModifyLoading = Observable<Bool>(false)
    let isDeleteLoading = Observable<Bool>(false)
    
    var isModifyValid: SafeSignal<Bool>{
        return combineLatest(isModifyLoading, isDeleteLoading, price) {isModifyLoading, isDeleteLoading, price in
            return !isModifyLoading && !isDeleteLoading && price != ""
        }
    }
    var isDeleteValid: SafeSignal<Bool>{
        return combineLatest(isModifyLoading, isDeleteLoading) {isModifyLoading, isDeleteLoading in
            return !isModifyLoading && !isModifyLoading
        }
    }
    
    let alertMessages = PublishSubject<String, NoError>()
    
    init(post: Post) {
        self.post = post
        title.value = post.title
        category.value = Category(rawValue: Int(post.category))
        condition.value = Condition(rawValue: Int(post.condition))
        price.value = String(post.price)
    }
    
    func modifyPost() {
        isModifyLoading.value = true
        let parameters = convertParameters()
        Alamofire.request(PostRouter.updatePost(id: post.id, parameters: parameters)).responseString { [unowned self] response in
            switch response.result {
            case .success:
                self.alertMessages.next("変更しました")
            case .failure(let error):
                self.alertMessages.next(error.localizedDescription)
            }
        }
        isModifyLoading.value = false
    }
    
    private func convertParameters() -> Parameters {
        price.value!.remove(at: price.value!.startIndex)
        let parameters: Parameters = [
            "category": category.value!.rawValue,
            "condition": condition.value!.rawValue,
            "price": Int64(price.value!)
        ]
        return parameters
    }
    
    func deletePost() {
        isDeleteLoading.value = true
        Alamofire.request(PostRouter.destroyPost(id: post.id)).responseString { [unowned self] response in
            switch response.result {
            case .success:
                self.alertMessages.next("削除しました")
            case .failure(let error):
                self.alertMessages.next(error.localizedDescription)
            }
        }
        isDeleteLoading.value = false
    }
    
}
