//
//  ConnectRefrigeratorUsercase.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/20.
//

import Foundation

class ConnectRefrigeratorUsecase {
    
    let repository = UserInfoRepository()
    
    func connectRefrigeratorByNFCTag(completion: @escaping(_ errorMessage:String?) -> Void){
        // 태그 시도
        NFCUtility.performAction(.readNFCIdentifier) { [weak self] result in
            do{
                let shelf = try result.get()
                self?.repository.connectRefrigerator(shelf: shelf, completion: completion)
            }catch{
                // 태깅 실패
                completion("태그에 실패하였습니다. 다시 시도해 주세요.")
            }
        }
    }
}
