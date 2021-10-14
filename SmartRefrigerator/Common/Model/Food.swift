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
    var maxWeight : Float
    var registeredDate : String
    var shelfID: Shelf
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case shelfID = "shelf_id"
        case foodName = "food_name"
        case foodWeight = "food_weight"
        case maxWeight = "max_weight"
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
    
    var remainedPercentage : Int{
        if maxWeight == 0.0 {
            return 100
        }
        return  Int(foodWeight / maxWeight) * 100
    }
    
    var registeredDateText : String{
        let date = registeredDate.split(separator: "-")
        let year = date[0].trimmingCharacters(in: .whitespaces)
        let month = date[1].trimmingCharacters(in: .whitespaces)
        let day = date[2].trimmingCharacters(in: .whitespaces)
        return "\(year)년 \(month)월 \(day)일"
    }
    
    var foodInfoText : String{
        var loc_row : String
        var loc_col : String
        if foodRow == 0 {
            loc_row = "뒷줄"
        }else{
            loc_row = "앞줄"
        }
        
        if foodCol == 0{
            loc_col = "왼쪽"
        }else if foodCol == 1 {
            loc_col = "가운데"
        }else{
            loc_col = "오른쪽"
        }
        
        return loc_row + " " + loc_col + "\n" + foodName.split(separator: "\n").joined()
    }
    
    var foodDetailInfoText : String {

        
        return "\(foodName.split(separator: "\n").joined())\n잔여량 \(remainedPercentage)%\n등록일 \(registeredDateText)\n등록일로부터 \(afterRegisteredDate)일 지났습니다."
    }
}
