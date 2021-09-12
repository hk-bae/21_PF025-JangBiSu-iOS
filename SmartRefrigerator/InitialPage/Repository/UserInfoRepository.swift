//
//  LoginRepository.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/11.
//

import Foundation

class UserInfoRepository {
    // 서버에 로그인 시도
    func login(id:String,pw:String,completion: @escaping (_ user:UserInfo?,_ errorMessage:String?) -> Void){
        AlamofireManager
            .shared
            .session
            .request(UserInfoRouter.login(id: id, pw: pw))
            .responseJSON{ response in
                
                switch response.result {
                case .success(let value) :
                    guard let result = value as? [String:Any] else { return }
                    
                    if response.response?.statusCode == 200 {
                        
                        if let user = result["data"] as? [String:Any]{
                            var shelf : Shelf?
                            if let shelfData = user["shelf"] as? [String:Any] {
                                shelf = Shelf(id: shelfData["id"] as! String,
                                              row: shelfData["row"] as! Int,
                                              col: shelfData["col"] as! Int
                                )
                            }
                            
                            UserInfo.savedUser = UserInfo(id: user["id"] as! String,
                                                          name: user["name"] as! String,
                                                          password: user["password"] as! String,
                                                          shelf: shelf)
                            
                            completion(UserInfo.savedUser,nil)
                        }
                        
                        
                    }else{
                        let errorMessage = result["errorMessage"] as? String
                        completion(nil,errorMessage)
                    }
                    
                case .failure :
                    break
                }
            }
    }
    
    func register(_ id:String, _ pw:String, _ name: String, completion : @escaping (_ user : UserInfo?,_ errorMessage : String?) -> Void ){
        
        AlamofireManager
            .shared
            .session
            .request(UserInfoRouter.register(id: id, pw: pw, name: name))
            .responseJSON{ response in
                
                switch response.result {
                case .success(let value) :
                    guard let result = value as? [String:Any] else{ return }
                    
                    if response.response?.statusCode == 201{
                        if let user = result["data"] as? [String:Any] {
                            UserInfo.savedUser = UserInfo(id: user["id"] as! String,
                                                          name: user["name"] as! String,
                                                          password: user["password"] as! String,
                                                          shelf: nil)
                        }
                        
                        completion(UserInfo.savedUser,nil)
                    }else{
                        let errorMessage = result["errorMessage"] as? String
                        completion(nil,errorMessage)
                    }
                case .failure :
                    break
                }
            }
    }
}
