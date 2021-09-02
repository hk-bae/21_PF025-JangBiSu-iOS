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
    
    // 서버에 로그인 시도
    func login(){
        let id = self.input.idTextField.value
        let pw = self.input.passwordTextField.value
        
        AlamofireManager
            .shared
            .session
            .request(UserInfoRouter.login(id: id, pw: pw))
            .responseJSON{ response in
            
                switch response.result {
                case .success(let value) :
                    guard let result = value as? [String:Any] else { return }
                    
                    if response.response?.statusCode == 200 {
                        let user = result["data"] as? UserInfo
                        UserInfo.savedUser = user
                        self.output.login.accept(LoginResult.success)
                        
                    }else{
                        let errorMessage = result["errorMessage"] as? String
                        switch errorMessage {
                        case "일치하는 회원 정보가 없습니다. 사용자 id를 확인해주세요.":
                            self.output.login.accept(LoginResult.nonexistentUser)
                            break
                        case "일치하는 회원 정보가 없습니다. 사용자 pw를 확인해주세요.":
                            self.output.login.accept(LoginResult.inconsistentUser)
                            break
                        default : break
                        }
                        
                    }
                    
                case .failure(let error) :
                    print(error)
                    break
                }
            }
    }
}

extension LoginViewModel {
    
    enum LoginResult {
        case success
        case inValidInput
        case nonexistentUser
        case inconsistentUser
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
