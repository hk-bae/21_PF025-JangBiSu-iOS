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
            print("SUCCESS")
            let main = UIHostingController(rootView: MainView())
            main.modalTransitionStyle = .crossDissolve
            main.modalPresentationStyle = .overFullScreen
            let navigationViewController = self.navigationController
            
            self.present(main, animated: true) {
                navigationViewController?.popViewController(animated: true)
            }
            
        case .inValidInput :
            let customDialog = CustomDialog(width: 300, height: 200, type: .OK)
            customDialog.setTitleLabel(text: "아이디 또는 비밀번호가\n유효하지 않습니다.")
            customDialog.show()
            
        case .failure :
            let customDialog = CustomDialog(width: 300, height: 200, type: .OK)
            customDialog.setTitleLabel(text: "아이디 또는 비밀번호가\n일치하지 않습니다.")
            customDialog.show()
        }
        
    }
}

extension LoginViewController {
    
    func createView(){
        createIdInputTextField()
        createPasswordInputTextField()
        createAutoLogin()
        createSaveId()
    }
    
    func createIdInputTextField(){
        idTextField.placeholder = "아이디"
        idTextField.keyboardType = .alphabet
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        idTextField.leftView = leftPadding
        idTextField.leftViewMode = .always
        
        // 아이디 저장
        if UserDefaults.standard.bool(forKey: CommonString.SAVE_ID.rawValue){
            idTextField.text = UserDefaults.standard.string(forKey: CommonString.SAVED_ID.rawValue)
        }
        
    }
    
    func createPasswordInputTextField(){
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordTextField.leftView = leftPadding
        passwordTextField.leftViewMode = .always
    }
    
    func createAutoLogin(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(autoLogin(_:)))
        autoLogin.addGestureRecognizer(tapGesture)
        
        let state = UserDefaults.standard.bool(forKey: CommonString.AUTO_LOGIN.rawValue)
        if state {
            autoLoginCheckBox.image = UIImage.init(systemName: "checkmark.circle.fill")
        }
    }
    
    func createSaveId(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveId(_:)))
        saveId.addGestureRecognizer(tapGesture)
        
        let state = UserDefaults.standard.bool(forKey: CommonString.SAVE_ID.rawValue)
        if state {
            saveIdCheckBox.image = UIImage.init(systemName: "checkmark.circle.fill")
        }
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
            autoLoginCheckBox.image = UIImage.init(systemName: "circle")
            UserDefaults.standard.set(false,forKey: CommonString.AUTO_LOGIN.rawValue)
        }
        else {
            autoLoginCheckBox.image = UIImage.init(systemName: "checkmark.circle.fill")
            UserDefaults.standard.set(true,forKey: CommonString.AUTO_LOGIN.rawValue)
        }
    }
    
    @objc func saveId(_ gesture : UIGestureRecognizer){
        let before = UserDefaults.standard.bool(forKey: CommonString.SAVE_ID.rawValue) //이전 값 가져오기
        
        // toogle
        if before {
            saveIdCheckBox.image = UIImage.init(systemName: "circle")
            UserDefaults.standard.set(false,forKey: CommonString.SAVE_ID.rawValue)
        }
        else {
            saveIdCheckBox.image = UIImage.init(systemName: "checkmark.circle.fill")
            UserDefaults.standard.set(true,forKey: CommonString.SAVE_ID.rawValue)
        }
    }
}
