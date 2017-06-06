//
//  UserRouter.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/29.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Alamofire

enum PostRouter: URLRequestConvertible {
    case createPost(parameters: Parameters)
    case fetchAllPost()
    case fetchPrivatePost(user_id: String)
    case fetchPostWithText(text: String)
    case fetchPostByCategory(category: Int)
    case updatePost(id: String, parameters: Parameters)
    case destroyPost(id: String)
    //case fetchAllPost(number: Int)
    
    static let host = Bundle.main.object(forInfoDictionaryKey: "baseURLString") as! String
    //static let host = "http://localhost:3001"
    
    var method: HTTPMethod {
        switch self {
        case .createPost:
            return .post
        case .fetchAllPost:
            return .get
        case .fetchPrivatePost:
            return .get
        case .fetchPostWithText:
            return .get
        case .fetchPostByCategory:
            return .get
        case .updatePost:
            return .put
        case .destroyPost:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createPost:
            return "/posts"
        case .fetchAllPost:
            return "/posts"
        case .fetchPrivatePost(let user_id):
            return "/posts/private/\(user_id)"
        case .fetchPostWithText(let text):
            return "/posts/text/\(text)"
        case .fetchPostByCategory(let category):
            return "/posts/category/\(category)"
        case .updatePost(let id, _):
            return "/posts/\(id)"
        case .destroyPost(let id):
            return "/posts/\(id)"
        //case .fetchAllPost(let number):
        //    return "/posts/all/\(number)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try PostRouter.host.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createPost(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updatePost(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
