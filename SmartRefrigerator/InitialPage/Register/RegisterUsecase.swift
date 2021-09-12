//
//  RegisterUsecase.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/12.
//

import Foundation

class RegisterUsecase{
    
    let repository = UserInfoRepository()
    
    func handleInputName(_ name: String) -> Bool{
        if name.count > 0 {
            return true
        }else{
            return false
        }
    }
    
    func handleInputId(_ id:String) -> Bool{
        if id.count == 0 {
            return false
        }else {
            // 영문, 숫자만 유효하도록
            let pattern = "^[A-Za-z0-9]{0,}$"
            let regex = try? NSRegularExpression(pattern: pattern)
            if let _ = regex?.firstMatch(in: id, options: [], range: NSRange(location: 0, length: id.count)){
                // 유효한 경우
                return true
            }
            return false
        }
    }
    
    func handleInputPw(_ pw:String) -> Bool{
        if pw.count < 6 {
            return false
        }else{
            return true
        }
    }
    
    func handleInputPwCheck(_ pwCheck:String,_ pw:String) -> Bool{
        if pwCheck.count >= 6 && pwCheck == pw {
            return true
        }else{
            return false
        }
    }
    
    
    func register(_ id:String, _ pw:String, _ name: String, completion : @escaping (_ user: UserInfo?,_ errorMessage: String?) -> Void ){
        repository.register(id, pw, name, completion: completion)
    }
}
