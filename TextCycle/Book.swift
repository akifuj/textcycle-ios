//
//  Book.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/25.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Book {
    
    let id: Int64
    let title: String!
    let author: String!
    let publisher: String!
    let listPrice: Int64
    let image: String?
    
    init(id: Int64, title: String!, author: String!, publisher: String!, listPrice: Int64, image: String?) {
        self.id = id
        self.title = title
        self.author = author
        self.publisher = publisher
        self.listPrice = listPrice
        self.image = image
    }
    /*
    static func fromJSON(_ json:[Data]) -> Book {
    
    }
 */
    
    static func fromRakutenApi(_ json:JSON) -> Book {
        let item = json[0]
        let title = item["title"].stringValue
        let author = item["author"].stringValue
        let publisher = item["publisherName"].stringValue
        let listPrice = item["itemPrice"].int64Value
        let image = item["largeImageUrl"].stringValue
        
        return Book(id: 0, title: title, author: author, publisher: publisher, listPrice: listPrice, image: image)
    }
}
