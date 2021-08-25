//
//  RegisterViewModel.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel : ViewModelType {
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    var validInput = [false,false,false,false]
    
    struct Input {
        let nameTextField = BehaviorRelay<String>(value:"")
        let pwTextField = BehaviorRelay<String>(value: "")
        let idTextField = BehaviorRelay<String>(value: "")
        let pwCheckTextField = BehaviorRelay<String>(value: "")
        
        let canRegister = BehaviorRelay<Bool>(value:false)
        let register = PublishRelay<Void>()
    }
    
    struct Output{
        let register = PublishRelay<RegisterResult>()
    }
    
    init(){
        // 각 텍스트 필드들에 대하여 subscribe을 통해 유효성 검증.
        // 유효하지 않는 경우 output.register에 Result를 전송하고 이를 뷰컨트롤러에서 통지 처리할 수 있도록 한다.
        input.nameTextField.asObservable()
            .subscribe(onNext:{ name in
                if name.count > 0 {
                    self.validInput[0] = true
                    self.output.register.accept(RegisterResult.validName)
                }else{
                    self.validInput[0] = false
                    self.output.register.accept(RegisterResult.invalidName)
                }
            }).disposed(by: disposeBag)
        
       
        
        input.idTextField.asObservable()
            .subscribe(onNext:{ id in
                if id.count == 0 {
                    self.validInput[1] = false
                    self.output.register.accept(RegisterResult.invalidId)
                }else {
                    // 영문, 숫자만 유효하도록
                    let pattern = "^[A-Za-z0-9]{0,}$"
                    let regex = try? NSRegularExpression(pattern: pattern)
                    if let _ = regex?.firstMatch(in: id, options: [], range: NSRange(location: 0, length: id.count)){
                        // 유효한 경우
                        self.validInput[1] = true
                        self.output.register.accept(RegisterResult.validId)
                    }else{
                        self.validInput[1] = false
                        self.output.register.accept(RegisterResult.invalidId)
                    }
                }
            }).disposed(by: disposeBag)
        
        input.pwTextField.asObservable()
            .subscribe(onNext:{pw in
                if pw.count < 6 {
                    self.validInput[2] = false
                    self.output.register.accept(RegisterResult.invalidPassword)
                }else{
                    self.validInput[2] = true
                    self.output.register.accept(RegisterResult.validPassword)
                }
            }).disposed(by: disposeBag)
        
        input.pwCheckTextField.asObservable()
            .subscribe(onNext:{ pwCheck in
                if pwCheck.count >= 6 && pwCheck == self.input.pwTextField.value {
                    self.validInput[3] = true
                    self.output.register.accept(RegisterResult.validCheckPassword)
                }else{
                    self.validInput[3] = false
                    self.output.register.accept(RegisterResult.invalidCheckPassword)
                }
            }).disposed(by: disposeBag)
        
        input.register.filter(isValid)
            .subscribe(onNext:{
                let id = self.input.idTextField.value
                let pw = self.input.pwTextField.value
                let name = self.input.nameTextField.value
                
                AlamofireManager
                    .shared
                    .session
                    .request(UserInfoRouter.register(id: id, pw: pw, name: name))
                    .responseDecodable(of:UserInfo.self){ response in
                        //회원가입 성공
                        if let user = response.value {
                            print(user.id)
                            UserInfo.savedUser = user // 사용자 정보 저장
                            self.output.register.accept(RegisterResult.success) // 성공 알림
                        // 회원가입 실패
                        }else{
                            self.output.register.accept(RegisterResult.alreadyExists) // 이미 존재하는 아이디
                        }
                    }
            }).disposed(by:disposeBag)
    }
}

extension RegisterViewModel {
    
    enum RegisterResult {
        case success
        case failure
        case validName
        case invalidName
        case validId
        case invalidId
        case alreadyExists
        case validPassword
        case invalidPassword
        case validCheckPassword
        case invalidCheckPassword
        case invalidInputRegister(term:String)
    }
    
    private func isValid() -> Bool {
        var valid = true
        var term = "" // 전달할 메세지
        for i in 0..<validInput.count {
            if validInput[i] == false {
                valid = false
                switch i {
                case 0:
                    term += "이름 "
                case 1:
                    term += "아이디 "
                case 2:
                    term += "비밀번호 "
                case 3:
                    term += "비밀번호 확인 "
                default:
                    break
                }
            }
        }
        
        if valid == false {
            output.register.accept(RegisterResult.invalidInputRegister(term: term))
        }
            
        
        return valid
    }
}
