//
//  BaseInterceptor.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import Foundation
import Alamofire

class BaseInterceptor : RequestInterceptor {
    
    // request 호출 시 함께 호출
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        // 헤더 부분 추가
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        completion(.success(request))
    }
    
}


