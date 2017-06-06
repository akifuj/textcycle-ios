//
//  UserRouter.swift
//  TextCycle
//
//  Created by 藤田哲史 on 2017/05/29.
//  Copyright © 2017年 Akifumi Fujita. All rights reserved.
//

import Foundation
import Alamofire

enum UserRouter: URLRequestConvertible {
    case createUser(parameters: Parameters)
    case fetchUser(id: String)
    case updateUser(id: String, parameters: Parameters)
    case destroyUser(id: String)
    case loginUser(parameters: Parameters)
    
    static let host = Bundle.main.object(forInfoDictionaryKey: "baseURLString") as! String
    //static let host = "http://localhost:3001"
    
    var method: HTTPMethod {
        switch self {
        case .createUser:
            return .post
        case .fetchUser:
            return .get
        case .updateUser:
            return .put
        case .destroyUser:
            return .delete
        case .loginUser:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .createUser:
            return "/users"
        case .fetchUser(let id):
            return "/users/\(id)"
        case .updateUser(let id, _):
            return "/users/\(id)"
        case .destroyUser(let id):
            return "/users/\(id)"
        case .loginUser:
            return "/auth"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try UserRouter.host.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateUser(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .loginUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
