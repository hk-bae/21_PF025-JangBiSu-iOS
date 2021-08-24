//
//  Food.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import Foundation

struct Food: Codable {
    let id: String
    let foodName: String
    let foodWeight, foodRow, foodCol: Int
    let shelfID: Shelf

    enum CodingKeys: String, CodingKey {
        case id
        case shelfID = "shelf_id"
        case foodName = "food_name"
        case foodWeight = "food_weight"
        case foodRow = "food_row"
        case foodCol = "food_col"
    }
}
