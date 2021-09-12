//
//  LoginService.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/11.
//

import Foundation


class LoginUsecase {
    
    let repositroy = UserInfoRepository()
    
    // 아이디 비밀번호 유효성 검사
    func isValid(id:String,pw:String, completion : @escaping (Bool) -> Void) -> Bool {
        var result : Bool
        
        if id.count > 0 && pw.count > 0 {
            result =  true
        }else{
            // 로그인 시도 실패
            result = false
        }
        completion(result)
        return result
    }
    
    func login(id:String,pw:String,completion:@escaping (_ user:UserInfo?,_ errorMessage:String?) -> Void){
        repositroy.login(id: id, pw: pw, completion: completion)
    }
    
}
