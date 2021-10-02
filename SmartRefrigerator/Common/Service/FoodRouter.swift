//
//  ShelfRouter.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/30.
//

import Foundation
import Alamofire

enum FoodRouter : URLRequestConvertible {
    
    case registerFood(id:String,food_name:String,food_row:Int,food_col:Int,registered_date:String,shelf_id:String)
    case fetchFoods(shelf_id:String)
    
    var method : HTTPMethod {
        switch self {
        case .registerFood : return .post
        case .fetchFoods : return .get
        }
    }
    
    var endPoint : String {
        switch self {
        case .registerFood(let id,_,_,_,_,_):
            return "food/\(id)"
        case .fetchFoods :
            return "food/all"
        }
    }
    
    var parameters : [String:String]{
        switch self {
        case let .registerFood(_,food_name,food_row,food_col,registered_date,shelf_id) :
            return ["food_name":food_name,"shelf_id":shelf_id,"food_row":String(food_row),"food_col":String(food_col),"registered_date" : registered_date]
        case .fetchFoods(let shelf_id) :
            return ["shelf_id":shelf_id]
        }
        
    }
    
    var baseURL : URL {
        switch self {
        case .registerFood, .fetchFoods :
            return URL(string: AlamofireManager.BASE_URL + self.endPoint)!
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        return request
    }
    
    
}
