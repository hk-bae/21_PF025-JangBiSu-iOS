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
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var autoLogin: UIStackView!
    @IBOutlet weak var autoLoginCheckBox: UIImageView!
    @IBOutlet weak var saveId: UIStackView!
    @IBOutlet weak var saveIdCheckBox: UIImageView!
    @IBOutlet weak var loginFailLabel: UILabel!
    lazy var clearIdButton = UIButton()
    lazy var clearPwButton = UIButton()
    
    private final let check_image = UIImage(named: "check_light")
    private final let uncheck_image = UIImage(named: "uncheck_light")
    
    @IBOutlet weak var loginFailLabelHeight: NSLayoutConstraint!
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.clearIdButton.rx.tap.asObservable()
            .subscribe(onNext:clearInputId)
            .disposed(by: disposeBag)
            
        
        self.clearPwButton.rx.tap.asObservable()
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
                print("냉장고 페이지로 이동")
            }
            
        case .inValidInput :
            configureLoginFailLabel(false)
            var text = ""
            if idTextField.text?.count == 0{
                idTextField.layer.borderColor = UIColor.Service.red.value.cgColor
                text = "아이디"
            }else{
                idTextField.layer.borderColor = UIColor.Service.gray.value.cgColor
            }
            
            if passwordTextField.text?.count == 0 {
                passwordTextField.layer.borderColor = UIColor.Service.red.value.cgColor
                if text.count == 0 {
                    text = "비밀번호"
                }else{
                    text += ", 비밀번호"
                }
            }else{
                passwordTextField.layer.borderColor = UIColor.Service.gray.value.cgColor
            }
            loginFailLabel.text = "\(text)을(를) 입력해주세요."
            
        case .nonexistentUser:
            configureLoginFailLabel(false)
            idTextField.layer.borderColor = UIColor.Service.red.value.cgColor
            passwordTextField.layer.borderColor = UIColor.Service.gray.value.cgColor
            loginFailLabel.text = "존재하지 않는 아이디 입니다."
            break
        case .inconsistentUser:
            configureLoginFailLabel(false)
            idTextField.layer.borderColor = UIColor.Service.gray.value.cgColor
            passwordTextField.layer.borderColor = UIColor.Service.red.value.cgColor
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
        
        idTextField.attributedPlaceholder = NSAttributedString(string: "아이디를 입력해 주세요.",attributes: [NSAttributedString.Key.foregroundColor: UIColor.Service.gray.value,NSAttributedString.Key.font: UIFont.Service.notoSans_regular(_size: 14).value])
        
        idTextField.keyboardType = .alphabet
        
        let leftPaddingSize = idTextField.frame.width * 20.0 / 330.0
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: leftPaddingSize, height: 0))
        
        idTextField.leftView = leftPadding
        idTextField.leftViewMode = .always
        
        let rightPaddingSize = idTextField.frame.width * 36.0 / 330.0
        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: rightPaddingSize, height: idTextField.frame.height))
        
        clearIdButton.setBackgroundImage(UIImage(named: "clear"), for: .normal)
        rightPadding.addSubview(clearIdButton)
        let buttonSize = idTextField.frame.width * 16.0 / 330.0
        clearIdButton.frame = CGRect(x: 0, y: rightPadding.frame.height / 2.0 - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        
        idTextField.rightView = rightPadding
        idTextField.rightViewMode = .always

        idTextField.layer.borderColor = UIColor.Service.gray.value.cgColor
        idTextField.layer.borderWidth = 2
        idTextField.layer.cornerRadius = idTextField.frame.height / 2.0
        idTextField.layer.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
        
        // 아이디 저장이 설정되어 있다면 아이디를 불러온다.
        if UserDefaults.standard.bool(forKey: CommonString.SAVE_ID.rawValue){
            idTextField.text = UserDefaults.standard.string(forKey: CommonString.SAVED_ID.rawValue)
        }
        
    }
    
    func createPasswordInputTextField(){
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력해 주세요.",attributes: [NSAttributedString.Key.foregroundColor: UIColor.Service.gray.value,NSAttributedString.Key.font: UIFont.Service.notoSans_regular(_size: 14).value])
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        
        let leftPaddingSize = idTextField.frame.width * 20.0 / 330.0
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: leftPaddingSize, height: 0))
        
        passwordTextField.leftView = leftPadding
        passwordTextField.leftViewMode = .always
        
        let rightPaddingSize = idTextField.frame.width * 36.0 / 330.0
        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: rightPaddingSize, height: passwordTextField.frame.height))
        
        clearPwButton.setBackgroundImage(UIImage(named: "clear"), for: .normal)
        rightPadding.addSubview(clearPwButton)
        let buttonSize = passwordTextField.frame.width * 16.0 / 330.0
        clearPwButton.frame = CGRect(x: 0, y: rightPadding.frame.height / 2.0 - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        
        passwordTextField.rightView = rightPadding
        passwordTextField.rightViewMode = .always
        
        passwordTextField.layer.borderColor = UIColor.Service.gray.value.cgColor
        passwordTextField.layer.borderWidth = 2
        passwordTextField.layer.cornerRadius = idTextField.frame.height / 2.0
        passwordTextField.layer.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
    }
    
    func createLoginButton(){
        loginButton.setTitleColor(UIColor.Service.white100.value, for: .normal)
        loginButton.layer.cornerRadius = loginButton.frame.height / 2.0
        loginButton.layer.backgroundColor = UIColor.Service.red.value.cgColor
        
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.red.cgColor
        
        loginButton.layer.shadowColor = UIColor.Service.red.value.cgColor
        loginButton.layer.shadowOffset = CGSize(width:0,height:5)
        loginButton.layer.shadowOpacity = 0.2
        loginButton.layer.shadowRadius = 5
        loginButton.layer.masksToBounds = false
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
