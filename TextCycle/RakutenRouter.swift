//
//  RakutenRouter.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/30.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Alamofire

enum RakutenRouter: URLRequestConvertible {
    case searchISBN(query: String)
    case searchTitle(query: String)
    case searchAuthor(query: String)
    
    static let baseURLString = Bundle.main.object(forInfoDictionaryKey: "rakuten-baseURLString") as! String
    
    func asURLRequest() throws -> URLRequest {
        let result: (Parameters) = {
            switch self {
            case let .searchISBN(query):
                return ["isbn": query]
            case let .searchTitle(query):
                return ["title": query]
            case let .searchAuthor(query):
                return ["author": query]
            }
        }()
        
        let url = try RakutenRouter.baseURLString.asURL()
        let urlRequest = URLRequest(url: url)
        return try URLEncoding.default.encode(urlRequest as URLRequestConvertible, with: result)
    }
}
