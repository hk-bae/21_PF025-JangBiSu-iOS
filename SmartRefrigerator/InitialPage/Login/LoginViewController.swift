//
//  LoginViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var idTextField: InputTextField!
    @IBOutlet weak var passwordTextField: InputTextField!
    @IBOutlet weak var autoLogin: UIStackView!
    @IBOutlet weak var autoLoginCheckBox: UIImageView!
    @IBOutlet weak var saveId: UIStackView!
    @IBOutlet weak var saveIdCheckBox: UIImageView!
    @IBOutlet weak var loginFailLabel: UILabel!
    
    private final let check_image = UIImage(named: "check_light")
    private final let uncheck_image = UIImage(named: "uncheck_light")
    
    @IBOutlet weak var loginFailLabelHeight: NSLayoutConstraint!
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Service.backgroundWhite.value
        createView()
        input()
        output()
    }
    
    @IBAction func backToInitialPage(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


extension LoginViewController {
    func input(){
        self.loginButton.rx.tap.asObservable()
            .debounce(.milliseconds(500),scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.login)
            .disposed(by: disposeBag)
        
        self.idTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.idTextField)
            .disposed(by: disposeBag)
        
        self.passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.passwordTextField)
            .disposed(by: disposeBag)
        
        self.idTextField.clearButton.rx.tap.asObservable()
            .subscribe(onNext:clearInputId)
            .disposed(by: disposeBag)
        
        
        self.passwordTextField.clearButton.rx.tap.asObservable()
            .subscribe(onNext:clearInputPw)
            .disposed(by: disposeBag)
    }
    
    func output(){
        self.viewModel.output.login.asObservable()
            .subscribe(onNext:handleLoginResult)
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    func handleLoginResult(result : LoginViewModel.LoginResult){
        switch result {
        case .success :
            // 로그인 성공 처리 -> 메인 페이지로 이동
            if let _ = UserInfo.savedUser?.shelf {
                let main = UIHostingController(rootView: MainView())
                main.modalTransitionStyle = .crossDissolve
                main.modalPresentationStyle = .overFullScreen
                let navigationViewController = self.navigationController
                
                self.present(main, animated: true) {
                    navigationViewController?.popViewController(animated: true)
                }
            }else{
                // 냉장고 등록 페이지로 이동
                guard let connectVC = self.storyboard?.instantiateViewController(identifier: "connectVC") else { fatalError() }
                navigationController?.pushViewController(connectVC, animated: true)
            }
            
        case .inValidInput :
            configureLoginFailLabel(false)
            var text = ""
            if idTextField.text?.count == 0{
                idTextField.configureView(true)
                text = "아이디"
            }else{
                idTextField.configureView(false)
            }
            
            if passwordTextField.text?.count == 0 {
                passwordTextField.configureView(true)
                if text.count == 0 {
                    text = "비밀번호"
                }else{
                    text += ", 비밀번호"
                }
            }else{
                passwordTextField.configureView(false)
            }
            loginFailLabel.text = "\(text)을(를) 입력해주세요."
            
        case .nonexistentUser:
            configureLoginFailLabel(false)
            idTextField.configureView(true)
            passwordTextField.configureView(false)
            loginFailLabel.text = "존재하지 않는 아이디 입니다."
            break
        case .inconsistentUser:
            configureLoginFailLabel(false)
            idTextField.configureView(false)
            passwordTextField.configureView(true)
            loginFailLabel.text = "아이디와 비밀번호가 일치하지 않습니다."
            break
        case .failure :
            break
        }
        
    }
}

extension LoginViewController {
    
    func createView(){
        createIdInputTextField()
        createPasswordInputTextField()
        createLoginButton()
        configureLoginFailLabel(true)
        createAutoLogin()
        createSaveId()
    }
    
    func createIdInputTextField(){
        idTextField.initView()
        idTextField.placeholder = "아이디를 입력해 주세요."
        idTextField.keyboardType = .alphabet
        
        // 아이디 저장이 설정되어 있다면 아이디를 불러온다.
        if UserDefaults.standard.bool(forKey: CommonString.SAVE_ID.rawValue){
            idTextField.text = UserDefaults.standard.string(forKey: CommonString.SAVED_ID.rawValue)
        }
        
    }
    
    func createPasswordInputTextField(){
        passwordTextField.initView()
        passwordTextField.placeholder = "비밀번호를 입력해 주세요."
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
    }
    
    func createLoginButton(){
        loginButton.layer.cornerRadius = loginButton.frame.height / 2.0
    }
    
    func configureLoginFailLabel(_ bool : Bool){
        
        loginFailLabel.isHidden = bool
        
        if !loginFailLabel.isHidden {
            // label 높이가 0일 때 높이  변경
            if loginFailLabelHeight.constant == 0 {
                loginFailLabelHeight.constant = loginFailLabel.intrinsicContentSize.height
                
                UIView.animate(withDuration: 0.2) {
                    self.loginFailLabel.layoutIfNeeded()
                }
            }
        }
        
    }
    
    
    func createAutoLogin(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(autoLogin(_:)))
        autoLogin.addGestureRecognizer(tapGesture)
        
        let state = UserDefaults.standard.bool(forKey: CommonString.AUTO_LOGIN.rawValue)
        if state {
            autoLoginCheckBox.image = check_image
        }
    }
    
    func createSaveId(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveId(_:)))
        saveId.addGestureRecognizer(tapGesture)
        
        let state = UserDefaults.standard.bool(forKey: CommonString.SAVE_ID.rawValue)
        if state {
            saveIdCheckBox.image = check_image
        }
    }
    
    func clearInputId(){
        self.idTextField.text = ""
    }
    
    func clearInputPw(){
        self.passwordTextField.text = ""
    }
}

// 키보드 처리
extension LoginViewController {
    // 화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ self.view.endEditing(true)
    }
    // 리턴키 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// 자동 로그인, 아이디 저장 처리
extension LoginViewController {
    @objc func autoLogin(_ gesture : UIGestureRecognizer){
        
        let before = UserDefaults.standard.bool(forKey: CommonString.AUTO_LOGIN.rawValue) //이전 값 가져오기
        
        // toogle
        if before {
            autoLoginCheckBox.image = uncheck_image
            UserDefaults.standard.set(false,forKey: CommonString.AUTO_LOGIN.rawValue)
        }
        else {
            autoLoginCheckBox.image = check_image
            UserDefaults.standard.set(true,forKey: CommonString.AUTO_LOGIN.rawValue)
        }
    }
    
    @objc func saveId(_ gesture : UIGestureRecognizer){
        let before = UserDefaults.standard.bool(forKey: CommonString.SAVE_ID.rawValue) //이전 값 가져오기
        
        // toogle
        if before {
            saveIdCheckBox.image = uncheck_image
            UserDefaults.standard.set(false,forKey: CommonString.SAVE_ID.rawValue)
        }
        else {
            saveIdCheckBox.image = check_image
            UserDefaults.standard.set(true,forKey: CommonString.SAVE_ID.rawValue)
        }
    }
}
