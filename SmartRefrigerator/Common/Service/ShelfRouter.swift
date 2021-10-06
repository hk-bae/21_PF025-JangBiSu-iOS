//
//  ShelfRouter.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/10/04.
//

import Foundation
import Alamofire

enum ShelfRouter : URLRequestConvertible {
    
    case getShelfInfo(shelfId:String)
    
    var method : HTTPMethod {
        switch self {
        case .getShelfInfo : return .get
        }
    }
    
    var endPoint : String {
        switch self {
        case .getShelfInfo(let shelfId) : return "shelf/\(shelfId)"
        }
    }
    
    var parameters : [String:String]{
        switch self {
        case .getShelfInfo : return [:]
        }
        
    }
    
    var baseURL : URL {
        switch self {
        case .getShelfInfo :
            return URL(string: AlamofireManager.BASE_URL + self.endPoint)!
         }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        return request
    }
    
    
}

