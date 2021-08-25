//
//  UserInfo.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import Foundation

struct UserInfo: Codable {
    let id, name, password: String
    var shelf: Shelf?
}

extension UserInfo {
    static var savedUser : UserInfo? {
        get{
            var user : UserInfo?
            if let data = UserDefaults.standard.value(forKey: CommonString.SAVED_USER.rawValue) as? Data {
                user = try? PropertyListDecoder().decode(UserInfo.self, from: data)
            }
            return user
        }
        
        set{
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: CommonString.SAVED_USER.rawValue)
        }
    }
}




