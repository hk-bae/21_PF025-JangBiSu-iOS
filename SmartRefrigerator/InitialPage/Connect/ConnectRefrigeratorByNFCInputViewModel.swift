//
//  InputShelfIdViewModel.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/20.
//

import Foundation
import RxSwift
import RxCocoa

class ConnectRefrigeratorByNFCInputViewModel : ViewModelType {
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    let usecase = ConnectRefrigeratorUsecase()
    
    struct Input{
        let submit = PublishRelay<Void>()
        let shelfIdInputTextField = BehaviorRelay<String>(value:"")
    }
    
    struct Output{
        let submit = PublishRelay<ConnectRefrigeratorViewModel.ConnectResult>()
    }
    
    init(){
        input.submit.asObservable()
            .subscribe(onNext:connectRefrigerator)
            .disposed(by: disposeBag)
    }
}


extension ConnectRefrigeratorByNFCInputViewModel {
    func connectRefrigerator(){
        let shelfId = self.input.shelfIdInputTextField.value
        usecase.connectRefrigeratorByNFCInput(shelfId: shelfId) { [weak self] error in
            if let error = error {
                self?.output.submit.accept(.failure(message: error))
            }else{
                self?.output.submit.accept(.success)
            }
        }
    }
}
