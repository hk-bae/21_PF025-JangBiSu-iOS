//
//  RegisterViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var nameInputTextField: InputTextField!
    @IBOutlet weak var idInputTextField: InputTextField!
    @IBOutlet weak var pwInputTextField: InputTextField!
    @IBOutlet weak var pwCheckInputTextField: InputTextField!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var goToLoginButton: UIButton!
    
    @IBOutlet weak var registerFailLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private let viewModel = RegisterViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Service.defaultBlack.value
        createView()
        input()
        output()
    }
    
    @IBAction func backToInitialPage(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension RegisterViewController {
    func input(){
        
        nameInputTextField.rx.text.orEmpty
            .bind(to: viewModel.input.nameTextField)
            .disposed(by: disposeBag)
        
        idInputTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.idTextField)
            .disposed(by: disposeBag)
        
        pwInputTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.pwTextField)
            .disposed(by: disposeBag)
        
        pwCheckInputTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.pwCheckTextField)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap.asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.register)
            .disposed(by: disposeBag)
        
        nameInputTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext: clearInputName)
            .disposed(by: disposeBag)
        
        idInputTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext: clearInputId)
            .disposed(by: disposeBag)
        
        pwInputTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext: clearInputPw)
            .disposed(by: disposeBag)
        
        pwCheckInputTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext: clearInputPwCheck)
            .disposed(by: disposeBag)
        
        goToLoginButton.rx.tap
            .asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext:goToLoginPage)
            .disposed(by: disposeBag)
    }
    
    func output(){
        viewModel.output.register
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:handleRegisterResult)
            .disposed(by: disposeBag)
    }
}

extension RegisterViewController {
    
    func createView(){
        createNameInputTextField()
        createIdInputTextField()
        createPasswordInputTextField()
        createCheckPasswordInputTextField()
        createRegisterButton()
        configureAccessibilityLabel()
        configureViews()
    }
    
    func createNameInputTextField(){
        nameInputTextField.setPlaceHolder("이름을 입력해 주세요.")
        nameInputTextField.configureAccessibilityLabel("이름")
        nameInputTextField.keyboardType = .default
    }
    
    
    func createIdInputTextField(){
        idInputTextField.setPlaceHolder("아이디를 입력하세요.(영문,숫자)")
        idInputTextField.configureAccessibilityLabel("아이디")
        idInputTextField.keyboardType = .alphabet
        
    }
    
    func createPasswordInputTextField(){
        pwInputTextField.setPlaceHolder("비밀번호를 입력하세요.(6자리 이상)")
        pwInputTextField.configureAccessibilityLabel("비밀번호")
        pwInputTextField.keyboardType = .default
        pwInputTextField.isSecureTextEntry = true
    }
    
    func createCheckPasswordInputTextField(){
        pwCheckInputTextField.setPlaceHolder("비밀번호를 다시 입력하세요.")
        pwCheckInputTextField.configureAccessibilityLabel("비밀번호 재입력")
        pwCheckInputTextField.keyboardType = .default
        pwCheckInputTextField.isSecureTextEntry = true
    }
    
    func createRegisterButton(){
        registerButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        registerButton.titleLabel?.textColor = UIColor.Service.defaultBlack.value
        registerFailLabel.textColor = UIColor.Service.orange.value
    }
    
    func configureAccessibilityLabel(){
        backButton.accessibilityLabel = "뒤로가기"
    }
    
    func configureViews(){
        view.layoutIfNeeded()
        registerButton.layer.cornerRadius = registerButton.frame.height / 2.0
        idInputTextField.initView()
        pwInputTextField.initView()
        nameInputTextField.initView()
        pwCheckInputTextField.initView()
    }
}

extension RegisterViewController {
    
    func handleRegisterResult(result : RegisterViewModel.RegisterResult){
        switch result{
        case .success :
            guard let connectVC = self.storyboard?.instantiateViewController(identifier: "connectVC") else { fatalError() }
            navigationController?.pushViewController(connectVC, animated: true)
        case .failure :
            break
        case.invalidName :
            self.nameInputTextField.configureView(true)
        case .validName :
            self.nameInputTextField.configureView(false)
        case .invalidId :
            self.idInputTextField.configureView(true)
        case .validId :
            self.idInputTextField.configureView(false)
        case .alreadyExists :
            self.idInputTextField.configureView(true)
            self.registerFailLabel.isHidden = false
            self.registerFailLabel.text = "이미 존재하는 아이디 입니다."
            TTSUtility.speak(string: self.registerFailLabel.text!)
            
        case .invalidPassword :
            self.pwInputTextField.configureView(true)
        case .validPassword :
            self.pwInputTextField.configureView(false)
        case .invalidCheckPassword :
            self.pwCheckInputTextField.configureView(true)
        case .validCheckPassword :
            self.pwCheckInputTextField.configureView(false)
        case let .invalidInputRegister(term) :
            self.registerFailLabel.isHidden = false
            self.registerFailLabel.text = term
            TTSUtility.speak(string: term)
        }
    }
    
    func goToLoginPage(){
        guard let loginVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginViewController else{
            fatalError()
        }
        let nc = self.navigationController
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            nc?.pushViewController(loginVC, animated: true)
        }
        self.navigationController?.popViewController(animated: true)
        CATransaction.commit()
    }

    
    func clearInputId(){
        self.idInputTextField.text = ""
        self.viewModel.input.idTextField.accept("")
    }
    
    func clearInputName(){
        self.nameInputTextField.text = ""
        self.viewModel.input.nameTextField.accept("")
    }
    func clearInputPw(){
        self.pwInputTextField.text = ""
        self.viewModel.input.pwTextField.accept("")
    }
    
    func clearInputPwCheck(){
        self.pwCheckInputTextField.text = ""
        self.viewModel.input.pwCheckTextField.accept("")
    }
}

extension RegisterViewController {
    //화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
