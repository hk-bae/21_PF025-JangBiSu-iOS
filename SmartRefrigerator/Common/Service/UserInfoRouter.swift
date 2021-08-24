//
//  Router.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import Foundation
import Alamofire

enum UserInfoRouter : URLRequestConvertible {
    
    case login(id:String,pw:String)
    case register(id:String,pw:String,name:String)
    case connect(id:String,shelfId:String)
    
    var method : HTTPMethod {
        switch self {
        case .login : return .get
        case .register : return .post
        case .connect : return .patch
        }
    }
    
    var endPoint : String {
        switch self {
        case .login, .register:
            return ""
        case .connect :
            return "connect/"
        }
    }
    
    var parameters : [String:String]{
        switch self {
        case let .login(_,pw) :
            return ["password":pw]
        case let .register(_,pw,name) :
            return ["password":pw,"name":name]
        case let .connect(_,shelfId):
            return ["shelf_id":shelfId]
        }
    }
    
    var baseURL : URL {
        switch self {
        case let .login(id,_), let .register(id,_,_), let .connect(id,_):
            return URL(string: AlamofireManager.BASE_URL + "user/" + "\(id)/")!
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        return request
    }
    
    
}
