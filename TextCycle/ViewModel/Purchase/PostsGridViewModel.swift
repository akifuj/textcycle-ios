//
//  PostsGridViewModel.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/27.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import Alamofire
import SwiftyJSON

class PostGridViewModel {
    
    let searchResults = MutableObservableArray<Post>([])
    let searchString = Observable<String?>(nil)
    let category = Observable<Category?>(nil)
    let isLoading = Observable<Bool>(false)
    
    let alertMessages = PublishSubject<String, NoError>()
    
    init() {
        exeuteSearch()
        
        _ = searchString
            .observeNext {
                [weak self] text in
                if let text = text {
                    self?.exeuteSearch(with: text)
                }
            }
        
        _ = category
            .observeNext {
                [weak self] category in
                if let category = category {
                    self?.exeuteSearch(by: category)
                } else {
                    self?.exeuteSearch()
                }
            }
    }
    
    private func exeuteSearch() {
        isLoading.value = true
        Alamofire.request(PostRouter.fetchAllPost()).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                self.searchResults.removeAll()
                let json = JSON(response.data)
                for (_, json) in json {
                    let post = Post.fromJSON(json)
                    self.searchResults.append(post)
                }
            case .failure(let error):
                self.alertMessages.next(error.localizedDescription)
            }
        }
        isLoading.value = false
    }
    
    private func exeuteSearch(with text: String) {
        isLoading.value = true
        Alamofire.request(PostRouter.fetchPostWithText(text: text)).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                self.searchResults.removeAll()
                let json = JSON(response.data)
                for (_, json) in json {
                    let post = Post.fromJSON(json)
                    self.searchResults.append(post)
                }
            case .failure(let error):
                self.alertMessages.next(error.localizedDescription)
            }
            if self.searchResults.count == 0 {
                self.alertMessages.next("検索結果はございませんでした")
            }
        }
        isLoading.value = false
    }
    
    private func exeuteSearch(by category: Category) {
        isLoading.value = true
        Alamofire.request(PostRouter.fetchPostByCategory(category: category.rawValue)).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                self.searchResults.removeAll()
                let json = JSON(response.data)
                for (_, json) in json {
                    let post = Post.fromJSON(json)
                    self.searchResults.append(post)
                }
            case .failure(let error):
                self.alertMessages.next(error.localizedDescription)
            }
        }
        isLoading.value = false
    }
    
    /*
     
    func loadmore() {
        if ( !isLoading.value ) {
            resultNumber += 30
            self.exeuteSearch()
        }
    }
    
    
     private func exeuteSearch() {
     isLoading.value = true
     Alamofire.request(PostRouter.fetchAllPost(number: resultNumber)).responseJSON { [unowned self] response in
     switch response.result {
     case .success:
     let json = JSON(response.data)
     for (_, json) in json {
     let post = Post.fromJSON(json)
     self.searchResults.append(post)
     }
     case .failure(let error):
     self.alertMessages.next(error.localizedDescription)
     }
     }
     isLoading.value = false
     }
     */
    
}
