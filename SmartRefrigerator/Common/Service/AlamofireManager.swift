//
//  AlamofireManager.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import Foundation
import Alamofire

final class AlamofireManager {
    
    //Singleton
    static let shared = AlamofireManager()
    static let BASE_URL = "http://localhost:8080/"
    
    let interceptors = Interceptor(interceptors:[
        BaseInterceptor()
    ])
    
    let monitors = [EventLogger()]

    var session : Session
    
    private init(){
        session = Session(interceptor : interceptors,eventMonitors: monitors)
    }
}
