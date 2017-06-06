//
//  Post.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/27.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Post {
    
    let id: String!
    let user_id: String!
    let buyer_id: String?
    let title: String!
    let author: String!
    let publisher: String!
    let listPrice: Int64
    let image: String?
    let category: Int64
    let condition: Int64
    let price: Int64

    init(id: String, user_id: String, buyer_id: String, title: String, author: String, publisher: String, listPrice: Int64, image: String, category: Int64, condition: Int64, price: Int64) {
        self.id = id
        self.user_id = user_id
        self.buyer_id = buyer_id
        self.title = title
        self.author = author
        self.publisher = publisher
        self.listPrice = listPrice
        self.image = image
        self.category = category
        self.condition = condition
        self.price = price
    }
    
    static func fromJSON(_ json:JSON) -> Post {
        let id = json["_id"].stringValue
        let user_id = json["user_id"].stringValue
        let buyer_id = json["buyer_id"].stringValue
        let title = json["title"].stringValue
        let author  = json["author"].stringValue
        let publisher = json["publisher"].stringValue
        let listPrice = json["listPrice"].int64Value
        let image = json["image"].stringValue
        let category = json["category"].int64Value
        let condition = json["condition"].int64Value
        let price = json["price"].int64Value
        
        return Post(id: id, user_id: user_id, buyer_id: buyer_id, title: title, author: author, publisher: publisher, listPrice: listPrice, image: image, category: category, condition: condition, price: price)
    }
    
    static func fromRakutenApi(_ json:JSON) -> Post {
        let item = json[0]
        let title = item["title"].stringValue
        let author = item["author"].stringValue
        let publisher = item["publisherName"].stringValue
        let listPrice = item["itemPrice"].int64Value
        let image = item["largeImageUrl"].stringValue
        
        return Post(id: "0", user_id: "0", buyer_id: "", title: title, author: author, publisher: publisher, listPrice: listPrice, image: image, category: 0, condition: 0, price: 0)
    }

}
