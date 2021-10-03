//
//  MainRepository.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/30.
//

import Foundation

class MainRepository{
    
    func fetchData(completion :@escaping(_ data : [Food], _ errorMessage: String?) -> Void){
        // fetch Data
        guard let shelfID = UserInfo.savedUser?.shelf?.id else {
            return
        }
        
        AlamofireManager
            .shared
            .session
            .request(FoodRouter.fetchFoods(shelf_id: shelfID))
            .responseJSON { response in
                
                let result = response.value as? [String:Any]
                if let datas = result?["data"] as? [[String:Any]]{
                    var newFoods : [Food] = []
                    for data in datas {
                        if let _ = data["food_row"] as? Int ,let _ =  data["food_col"] as? Int{
                        let newFood = Food(id: data["id"] as! String, foodName: data["food_name"] as! String, foodRow: data["food_row"] as! Int, foodCol: data["food_col"] as! Int, foodWeight: data["food_weight"] as? Float ?? 0.0,  registeredDate: data["registered_date"] as! String, shelfID: Shelf(id: shelfID, row: 2, col: 3))
                            newFoods.append(newFood)
                        }
                        
                        
                    }
                    completion(newFoods,nil)
                }
            }
    }
    
    // 반찬통 등록
    func registerFood(foodId : String, foodName:String,
                      foodRow:Int,foodCol:Int,registeredDate: String,completion : @escaping(_ newFood:Food?,_ errorMessage : String?) -> Void){
        // 사용자에게 등록된 냉장고 선반 ID 가져오기
        guard let shelfID = UserInfo.savedUser?.shelf?.id else {
            return
        }
        AlamofireManager
            .shared
            .session
            .request(FoodRouter.registerFood(id: foodId, food_name: foodName,food_row: foodRow,food_col: foodCol,registered_date:registeredDate,shelf_id: shelfID))
            .responseJSON { response in
                
                if response.response?.statusCode == 204{ // 성공
                    let newFood = Food(id: foodId, foodName: foodName, foodRow: foodRow, foodCol: foodCol, foodWeight: 0.0, registeredDate: registeredDate, shelfID: Shelf(id: shelfID, row: 2, col: 3))
                    completion(newFood,nil)
                }else{
                    // 존재하지 않는 선반 정보 또는 이미 등록된 반찬통
                    let result = response.value as? [String:Any]
                    let errorMessage = result?["errorMessage"] as? String
                    
                    completion(nil, errorMessage)
                }
            }
        
    }
    
    //반찬통 정보 갱신
    func modifyFood(foodId:String, foodName:String, completion: @escaping () -> Void){
        AlamofireManager
            .shared
            .session
            .request(FoodRouter.modifyFood(id: foodId, food_name: foodName))
            .responseJSON { response in
                if response.response?.statusCode == 204 {
                    completion()
                }
            }
    }
}
