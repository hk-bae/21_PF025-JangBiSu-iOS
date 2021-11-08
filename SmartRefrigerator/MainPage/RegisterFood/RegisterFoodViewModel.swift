//
//  RegisterFoodViewModel.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/10/01.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterFoodViewModel : ViewModelType {
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    struct Input{
        let submit = PublishRelay<Void>()
        let foodNameInputTextField = BehaviorRelay<String>(value: "")
    }
    
    struct Output{
        let submit = PublishRelay<RegisterFoodResult>()
    }
    
    init(){
        input.submit.asObservable()
            .withLatestFrom(input.foodNameInputTextField)
            .filter({ [weak self] foodName in
                return self?.isValid(foodName) ?? false
            })
            .map({[weak self] foodName in
                guard let self = self else { fatalError() }
                return self.handleNameField(foodName)
            })
            .bind(to: output.submit)
            .disposed(by: disposeBag)
    }
}

extension RegisterFoodViewModel{
    enum RegisterFoodResult{
        case success(term:String)
        case invalidInput
    }
}

extension RegisterFoodViewModel {
    func isValid(_ string: String) -> Bool{
        let string = string.trimmingCharacters(in: .whitespaces) // 공백 제거
        
        if string.count > 0 && string.count <= 6 {
            return true
        }
        output.submit.accept(RegisterFoodResult.invalidInput)
        return false
    }
    
    func handleNameField(_ string : String) -> RegisterFoodResult{
        let string = string.trimmingCharacters(in: .whitespaces) // 공백 제거
    
        var newString = ""
        let words = string.components(separatedBy: " ")
        if words.count == 1 {
            if words[0].count <= 3 {
                newString = words[0]
            }else{
                let mid = Int(ceil(Double(words[0].count / 2)))
                
                let index = words[0].index(words[0].startIndex, offsetBy: mid)
                newString = String(words[0][..<index]) + "\n" + String(words[0][index...])
            }
        }else if words.count == 2{
            if words[0].count <= 3 && words[1].count <= 3 {
                newString = words[0] + "\n" + words[1]
            }else if words[0].count > 3{
                let index = words[0].index(words[0].startIndex, offsetBy: 4)
                newString = String(words[0][..<index]) + "\n" + String(words[0][index...]) + words[1]
            }else {
                let index = words[1].index(words[1].startIndex, offsetBy: words[1].count - 3)
                newString =  words[0] + String(words[1][..<index]) + "\n" + String(words[1][index...])
            }
        }else{
            for word in words {
                for ch in word {
                    newString.append(ch)
                }
            }
            return handleNameField(newString)
        }
        
        return RegisterFoodResult.success(term: newString)
    }
}
