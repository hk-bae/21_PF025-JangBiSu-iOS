//
//  LoginViewModel.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {
    struct Input {
        let login = PublishRelay<Void>()
        let idTextField = BehaviorRelay<String>(value:"")
        let passwordTextField = BehaviorRelay<String>(value:"")
    }
    
    struct Output {
        let login = PublishRelay<LoginResult>()
    }
    
    let input = Input()
    let output = Output()
    
    let disposeBag = DisposeBag()
    
    init(){
        // input
        
        // 아이디 저장되어있으면 저장함
        self.input.idTextField.asObservable()
            .filter({ string -> Bool in
                UserDefaults.standard.bool(forKey: CommonString.SAVE_ID.rawValue) && string.count > 0
            })
            .subscribe(onNext:{ string in
                UserDefaults.standard.set(string, forKey:CommonString.SAVED_ID.rawValue)
            })
            .disposed(by:disposeBag)
        
        //login 버튼 클릭 시 아이디, 패쓰워드 유효성 검사 후 로그인 시도, output.login에 통지
        self.input.login.asObservable()
            .filter(isValid)
            .subscribe(onNext:{
                let id = self.input.idTextField.value
                let pw = self.input.passwordTextField.value
                print(id,pw)
                AlamofireManager
                    .shared
                    .session
                    .request(UserInfoRouter.login(id: id, pw: pw))
                    .responseDecodable(of:UserInfo.self){ response in
                        //로그인 성공
                        if let user = response.value {
                            UserInfo.savedUser = user // 사용자 정보 저장
                            self.output.login.accept(LoginResult.success) // 성공 알림
                        // 로그인 실패
                        }else{
                            self.output.login.accept(LoginResult.failure) // 실패 알림
                        }
                    }
            })
            .disposed(by:disposeBag)
        
        
    }
}

extension LoginViewModel {
    
    enum LoginResult {
        case success
        case inValidInput
        case failure
    }
    
    // 아이디 비밀번호 유효성 검사
    private func isValid() -> Bool {
        let id = self.input.idTextField.value
        let pw = self.input.passwordTextField.value
        
        if id.count > 0 && pw.count > 0 {
            return true
        }
        // 로그인 시도 실패
        output.login.accept(LoginResult.inValidInput)
        return false
    }
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
