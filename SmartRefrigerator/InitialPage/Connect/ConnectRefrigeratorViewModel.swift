//
//  ConnectRefrigeratorViewModel.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/20.
//

import Foundation
import RxSwift
import RxCocoa

class ConnectRefrigeratorViewModel : ViewModelType {
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    let usecase = ConnectRefrigeratorUsecase()
    
    struct Input {
        let nfcButton = PublishRelay<Void>()
        let nfcIdInputButton = PublishRelay<Void>()
    }
    
    struct Output{
        let connectRefrigerator = PublishRelay<ConnectResult>()
    }
    
    init(){
        input.nfcButton.asObservable()
            .subscribe(onNext:nfcTag)
            .disposed(by: disposeBag)
    }
}

extension ConnectRefrigeratorViewModel {
    enum ConnectResult{
        case success
        case failure(message:String)
    }
    
    func nfcTag(){
        usecase.connectRefrigeratorByNFCTag{ [weak self] error in
            if let error = error {
                // 실패
                self?.output.connectRefrigerator.accept(.failure(message: error))
            }else{
                // 성공
                self?.output.connectRefrigerator.accept(.success)
            }
        }
    }
    
}
