//
//  MainUsecase.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/30.
//

import Foundation

class MainUsecase {
    let repository = MainRepository()
    
    func fetchData(completion:@escaping ([Food?]) -> Void){
        repository.fetchData { rawValue, _ in
            var foodsArray : [Food?] = [nil,nil,nil,nil,nil,nil]
            for food in rawValue {
                let row = food.foodRow
                let col = food.foodCol
                let index = row * 3 + col
                foodsArray[index] = food
            }
            completion(foodsArray)
        }
    }
    
    func registerFood(index:Int,foodName:String,completion :@escaping(_ newFood:Food?,_ errorMessage:String?) -> Void){
        NFCUtility.performAction(.readNFCIdentifier(kindOf: .food)) { [weak self] result in
            do{
                let foodId = try result.get()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy - MM - dd"
                let registeredDate = dateFormatter.string(from: Date())
                
                self?.repository.registerFood(foodId: foodId, foodName: foodName,foodRow:index / 3,foodCol:index % 3,registeredDate: registeredDate,completion: completion)
            }catch{
                // 태깅 실패
                completion(nil,"태그에 실패하였습니다. 다시 시도해 주세요.")
            }
        }
    }
    
    func inquireFood(){
        
    }
    
    
    func handleCheckingIce(){
        
    }
}