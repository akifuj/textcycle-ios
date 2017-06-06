//
//  SearchTableViewModel.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/30.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import Alamofire
import SwiftyJSON

class SearchViewModel {
    
    let searchResults = MutableObservableArray<String>([])
    
    let isLoading = Observable<Bool>(false)
    
    let errorMessages = PublishSubject<String, NoError>()
    
    func exeuteSearchTitle(with text: String) {
        isLoading.value = true
        Alamofire.request(RakutenRouter.searchTitle(query: text)).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                self.searchResults.removeAll()
                let json = JSON(response)
                if (json["count"]).int64Value > 0 {
                    for (_, json) in json["Items"] {
                        let text = json["title"].stringValue
                        self.searchResults.append(text)
                    }
                } else {
                    self.exeuteSearchAuthor(with: text)
                }
            case .failure(let error):
                self.errorMessages.next(error.localizedDescription)
            }
        }
        isLoading.value = false
    }
    
    private func exeuteSearchAuthor(with text: String) {
        Alamofire.request(RakutenRouter.searchTitle(query: text)).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                let json = JSON(response.data)
                if (json["count"]).int64Value > 0 {
                    for (_, json) in json["Items"] {
                        let text = json["title"].stringValue
                        self.searchResults.append(text)
                    }
                }
            case .failure(let error):
                self.errorMessages.next(error.localizedDescription)
            }
        }
    }

}
