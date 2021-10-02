//
//  Food.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import Foundation

struct Food: Codable {
    let id: String
    var foodName: String
    var foodRow, foodCol: Int
    var foodWeight : Float
    var registeredDate : String
    var shelfID: Shelf
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case shelfID = "shelf_id"
        case foodName = "food_name"
        case foodWeight = "food_weight"
        case foodRow = "food_row"
        case foodCol = "food_col"
        case registeredDate = "registered_date"
    }
}

extension Food {
    var afterRegisteredDate : Int {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy - MM - dd"
        let date = dateFormatter.date(from: registeredDate)
        
        let days = Calendar.current.dateComponents([.day], from: date!, to:today).day! + 1

        return days - 1
    }
}
