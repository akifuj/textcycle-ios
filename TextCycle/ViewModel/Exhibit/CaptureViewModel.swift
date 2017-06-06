//
//  CaptureViewModel.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/25.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import Alamofire
import SwiftyJSON

enum RequestState {
    case None
    case Requesting
    case Found
}

class CaptureViewModel {
    
    let isbn = Observable<String?>("")
    var newPost: Post?
    
    let requestState = Observable<RequestState>(.None)
    var isLoading: SafeSignal<Bool> {
        return requestState.map { $0 == .Requesting }
    }
    
    let alertMessages = PublishSubject<String, NoError>()
    
    init() {
        _ = isbn
            .filter { self.checkISBN(value: $0!) }
            .throttle(seconds: 3.0)
            .observeNext {
                [unowned self] isbn in
                if let isbn = isbn {
                    self.executeSearch(with: isbn)
                }
            }
    }
    
    private func checkISBN(value: String) -> Bool {
        let v = NSString(string: value).longLongValue
        let prefix: Int64 = Int64(v / 10000000000)
        if prefix == 978 || prefix == 979 {
            return true
        }
        return false
    }
    
    private func executeSearch(with isbn: String) {
        requestState.next(.Requesting)
        rakutenSearch(with: isbn)
        requestState.next(.None)
    }
    
    private func rakutenSearch(with isbn: String) {
        Alamofire.request(RakutenRouter.searchISBN(query: isbn)).responseJSON { [unowned self] response in
            switch response.result {
            case .success:
                let json = JSON(response.data)
                if (json["count"]).int64Value > 0 {
                    self.newPost = Post.fromRakutenApi(json["Items"])
                    self.requestState.next(.Found)
                } else {
                    self.alertMessages.next("書籍情報は見つかりませんでした")
                }
            case .failure(let error):
                self.alertMessages.next(error.localizedDescription)
            }
        }
    }
    
}
