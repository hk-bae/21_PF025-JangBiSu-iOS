//
//  EventMonitor.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import Foundation
import Alamofire

final class EventLogger : EventMonitor {
    
    let queue = DispatchQueue(label:"ApiLog")
    
    //request 끝났는지
    func requestDidFinish(_ request: Request) {
        Swift.print("EventLogger - requestDidFinish()")
    }
    
    //request 취소됐는지
    func requestDidCancel(_ request: Request) {
        Swift.print("EventLogger - requestDidCancel()")
    }
    
    //request 재시도됐는지
    func requestIsRetrying(_ request: Request) {
        Swift.print("EventLogger - requestIsRetrying()")
    }
    
    // request가 잘 갔는지
    func requestDidResume(_ request: Request){
        Swift.print("EventLogger - requestDidResumse()")
        debugPrint(request)
    }
    
    // response를 잘 파싱했는지
    func request<Value>(_ request: DataRequest, didParseResponse response : DataResponse<Value,AFError>){
        // statusCode
        guard let statusCode = request.response?.statusCode else { return }
        print("EventLogger - request.didParseRsponse()")
        debugPrint(response)
    }
}
