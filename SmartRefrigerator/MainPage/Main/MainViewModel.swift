//
//  MainViewModel.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/30.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel : ViewModelType {
        
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    let usecase = MainUsecase()
    
//    // 해당 칸의 반찬통 등록 여부
//    var isRegistered = BehaviorRelay<[Bool]>(value:[false,false,false,false,false,false])
    
    var foods = BehaviorRelay<[Food?]>(value:[nil,nil,nil,nil,nil,nil])
    
    struct Input {
        let foodTouch = PublishRelay<Int>() // i번째 위치에서 탭이 이루어짐
        let registerFood = PublishRelay<(Int,String)>()
        let modifyFood = PublishRelay<(Int,String)>()
        let checkIce = PublishRelay<Void>()
    }
    
    struct Output {
        let foodTouch = PublishRelay<FoodTouchResult>()
        let registerFood = PublishRelay<FoodRegisterResult>()
        let updateFoods = PublishRelay<Void>()
    }
    
    init(){
        input.foodTouch.asObservable()
            .subscribe(onNext:handleTouchingFood)
            .disposed(by: disposeBag)
    
        input.registerFood.asObservable()
            .subscribe(onNext:registerFood)
            .disposed(by: disposeBag)
       
        input.modifyFood.asObservable()
            .subscribe(onNext:modifyFood)
            .disposed(by: disposeBag)
        
        input.checkIce.asObservable()
            .subscribe(onNext:handleCheckingIce)
            .disposed(by: disposeBag)
        
        foods.asObservable()
            .map { _ in }
            .bind(to: output.updateFoods)
            .disposed(by: disposeBag)
        
            
    }
}

extension MainViewModel {
    
    func fetchData(){
        usecase.fetchData { [weak self] foodsArray in
            guard let self = self else { fatalError() }
            self.foods.accept(foodsArray)
        }
    }
    
    
    // 초기 반찬통 터치 시에 handle
    func handleTouchingFood(_ index : Int){
        if let _ = foods.value[index] {
            output.foodTouch.accept(.inquireResult(index:index))
        }else{
            // 반찬 등록을 위해 반찬이름 bottom sheet 띄우라고 알림
            output.foodTouch.accept(.needToRegister(index: index))
        }
        
    }
    
    
    func registerFood(_ foodInfo : (Int,String)){
        let index = foodInfo.0
        let foodName = foodInfo.1
        usecase.registerFood(index : index, foodName: foodName) { [weak self] food,errorMessage in
            guard let self = self else { fatalError() }
            if let errorMessage = errorMessage {
                self.output.registerFood.accept(.failure(errorMessage))
                return
            }
            self.updateFoods(index: index, food: food)
        }
    }
    
    func modifyFood(_ foodInfo : (Int,String)){
        let index = foodInfo.0
        let foodName = foodInfo.1
        if let foodId = foods.value[index]?.id {
            usecase.modifyFood(foodId: foodId, foodName: foodName, completion: {
                self.fetchData()
            })
        }
        
    }
    
    func updateFoods(index: Int,food : Food?){
        var newValue = self.foods.value
        newValue[index] = food
        self.foods.accept(newValue)
    }
    

    
    func handleCheckingIce(){
        
    }
}

extension MainViewModel {
    
    enum FoodTouchResult{
        case needToRegister(index:Int)
        case inquireResult(index:Int)
    }
    
    enum FoodRegisterResult{
        case success
        case failure(_ errorMessage: String)
    }
    
}
