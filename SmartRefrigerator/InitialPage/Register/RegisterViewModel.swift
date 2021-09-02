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
            .subscribe(onNext:handleInputName)
            .disposed(by: disposeBag)
        
        input.idTextField.asObservable()
            .subscribe(onNext:handleInputId)
            .disposed(by: disposeBag)
        
        input.pwTextField.asObservable()
            .subscribe(onNext:handleInputPw)
            .disposed(by: disposeBag)
        
        input.pwCheckTextField.asObservable()
            .subscribe(onNext:handleInputPwCheck).disposed(by: disposeBag)
        
        input.register.filter(isValid)
            .subscribe(onNext:register).disposed(by:disposeBag)
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
        var terms : [String] = [] // 전달할 메세지
        for i in 0..<validInput.count {
            if validInput[i] == false {
                valid = false
                switch i {
                case 0:
                    terms.append("이름")
                    self.output.register.accept(.invalidName)
                case 1:
                    terms.append("아이디")
                    self.output.register.accept(.invalidId)
                case 2:
                    terms.append("비밀번호")
                    self.output.register.accept(.invalidPassword)
                case 3:
                    terms.append("비밀번호 확인")
                    self.output.register.accept(.invalidCheckPassword)
                default:
                    break
                }
            }else{
                switch i {
                case 0:
                    self.output.register.accept(.validName)
                case 1:
                    self.output.register.accept(.validId)
                case 2:
                    self.output.register.accept(.validPassword)
                case 3:
                    self.output.register.accept(.validCheckPassword)
                default:
                    break
                }
            }
        }
        
        if valid == false {
            let term = terms.joined(separator: ",") + "이(가) 올바르지 않습니다."
            output.register.accept(RegisterResult.invalidInputRegister(term: term))
        }
        
        
        return valid
    }
}

extension RegisterViewModel {
    
    func register(){
        let id = self.input.idTextField.value
        let pw = self.input.pwTextField.value
        let name = self.input.nameTextField.value
        print("#password",pw)
        AlamofireManager
            .shared
            .session
            .request(UserInfoRouter.register(id: id, pw: pw, name: name))
            .responseJSON{ response in
                
                switch response.result {
                case .success(let value) :
                    guard let result = value as? [String:Any] else{ return }
                    
                    if response.response?.statusCode == 201{
                        let user = result["data"] as? UserInfo
                        UserInfo.savedUser = user
                        self.output.register.accept(RegisterResult.success)
                    }else{
                        self.output.register.accept(RegisterResult.alreadyExists) // 이미 존재하는 아이디
                    }
                case .failure :
                    break
                }
            }
    }
    func handleInputName(_ name: String){
        if name.count > 0 {
            self.validInput[0] = true
            self.output.register.accept(RegisterResult.validName)
        }else{
            self.validInput[0] = false
        }
    }
    
    func handleInputId(_ id:String){
        if id.count == 0 {
            self.validInput[1] = false
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
            }
        }
    }
    
    func handleInputPw(_ pw:String){
        if pw.count < 6 {
            self.validInput[2] = false
        }else{
            self.validInput[2] = true
            self.output.register.accept(RegisterResult.validPassword)
        }
    }
    
    func handleInputPwCheck(_ pwCheck:String){
        if pwCheck.count >= 6 && pwCheck == self.input.pwTextField.value {
            self.validInput[3] = true
            self.output.register.accept(RegisterResult.validCheckPassword)
        }else{
            self.validInput[3] = false
        }
    }
}

