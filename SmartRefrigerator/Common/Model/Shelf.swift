//
//  Shelf.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import Foundation
struct Shelf: Codable {
    let id: String
    let row, col: Int
    var ice : Bool = false
}
