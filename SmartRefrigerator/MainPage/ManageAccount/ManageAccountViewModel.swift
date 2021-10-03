//
//  MangeAccountViewModel.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/10/02.
//

import Foundation
import RxSwift
import RxCocoa

class ManageAccountViewModel : ViewModelType {
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    struct Input{
        let backButton = PublishRelay<Void>()
        let nfcButton = PublishRelay<Void>()
        let logoutButton = PublishRelay<Void>()
    }
    
    struct Output{
        let result = PublishRelay<ButtonClickResult>()
    }
    
    init(){
        input.backButton.asObservable()
            .map({_ in ManageAccountViewModel.ButtonClickResult.back})
            .bind(to: output.result)
            .disposed(by: disposeBag)
        
        input.nfcButton.asObservable()
            .map({_ in ManageAccountViewModel.ButtonClickResult.nfc})
            .bind(to: output.result)
            .disposed(by: disposeBag)
        
        input.logoutButton.asObservable()
            .map({_ in ManageAccountViewModel.ButtonClickResult.logout})
            .bind(to: output.result)
            .disposed(by: disposeBag)
    }
}

extension ManageAccountViewModel{
    enum ButtonClickResult{
        case back
        case nfc
        case logout
    }
}
