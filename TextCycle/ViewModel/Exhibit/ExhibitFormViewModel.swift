//
//  ExhibitFormViewModel.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/26.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import Alamofire
import SwiftyJSON

class ExhibitFormViewModel {
    
    let post: Post
    
    let title = Observable<String?>("")
    let author = Observable<String?>("")
    let publisher = Observable<String?>("")
    let listPrice = Observable<String?>("")
    let category = Observable<Category>(.Commerce)
    let condition = Observable<Condition>(.Better)
    let price = Observable<String?>("")
    
    let isLoading = Observable<Bool>(false)
    var isValid: SafeSignal<Bool>{
        return combineLatest(isLoading, price) {isLoading, price in
            return !isLoading && price != ""
        }
    }
    
    let alertMessages = PublishSubject<String, NoError>()
    
    init(post: Post) {
        self.post = post
        title.value = post.title
        author.value = post.author
        publisher.value = post.publisher
        listPrice.value = String(post.listPrice)
    }
    
    func exhibit() {
        isLoading.value = true
        let parameters = convertParameters()
        Alamofire.request(PostRouter.createPost(parameters: parameters)).responseString { [unowned self] response in
            switch response.result {
            case .success:
                self.alertMessages.next("出品しました")
            case .failure(let error):
                self.alertMessages.next(error.localizedDescription)
            }
        }
        isLoading.value = false
    }
    
    private func convertParameters() -> Parameters {
        price.value!.remove(at: price.value!.startIndex)
        let parameters: Parameters = [
            "user_id": ud.object(forKey: "id") as! String,
            "buyer_id": "",
            "title": post.title,
            "author": post.author,
            "publisher": post.publisher,
            "listPrice": post.listPrice,
            "image": post.image!,
            "category": category.value.rawValue,
            "condition": condition.value.rawValue,
            "price": Int64(price.value!)
        ]
        return parameters
    }
    
}
