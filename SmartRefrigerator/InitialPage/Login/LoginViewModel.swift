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
    
    let usecase = LoginUsecase()
    
    init(){
        // input
        // 아이디 저장 체크 되어있으면 저장함
        self.input.idTextField.asObservable()
            .filter(checkSaveId)
            .subscribe(onNext:saveId)
            .disposed(by:disposeBag)
        
        //login 버튼 클릭 시 아이디, 패쓰워드 유효성 검사 후 로그인 시도, output.login에 통지
        self.input.login.asObservable()
            .filter(isValid)
            .subscribe(onNext:login)
            .disposed(by:disposeBag)
        
        
    }
}

extension LoginViewModel {
    
    // 아이디 저장 체크 상태인지 확인
    func checkSaveId(id : String) -> Bool{
        return UserDefaults.standard.bool(forKey: CommonString.SAVE_ID.rawValue) && id.count > 0
    }
    
    // 아이디 저장
    func saveId(id :String){
        UserDefaults.standard.set(id, forKey:CommonString.SAVED_ID.rawValue)
    }
    
    
    // 아이디 유효성 검사
    func isValid() -> Bool{
        return usecase.isValid(id: input.idTextField.value, pw: input.passwordTextField.value) { [weak self] isValid in
            if !isValid {
                var text = ""
                if self?.input.idTextField.value.count == 0{
                    text = "아이디"
                }
                if self?.input.passwordTextField.value.count == 0 {
                    if text.count == 0 {
                        text = "비밀번호"
                    }else{
                        text += ", 비밀번호"
                    }
                }
                self?.output.login.accept(LoginResult.inValidInput(text: text))
            }
        }
    }
    
    func login() {
        usecase.login(id: input.idTextField.value, pw: input.passwordTextField.value) { [weak self] user, errorMessage in
            if let _ = user {
                self?.output.login.accept(LoginResult.success)
            }
            
            if let errorMessage = errorMessage {
                switch errorMessage {
                case errorMessage where errorMessage.contains("id"):
                    self?.output.login.accept(LoginResult.nonexistentUser)
                    break
                case errorMessage where errorMessage.contains("pw"):
                    self?.output.login.accept(LoginResult.inconsistentUser)
                    break
                default : break
                }
            }
        }
    }
    
}

extension LoginViewModel {
    
    enum LoginResult {
        case success
        case inValidInput(text:String)
        case nonexistentUser
        case inconsistentUser
        case failure
    }
    
    
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
