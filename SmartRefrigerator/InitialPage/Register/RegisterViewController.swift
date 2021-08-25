//
//  RegisterViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameInputTextField: UITextField!
    @IBOutlet weak var idInputTextField: UITextField!
    @IBOutlet weak var pwInputTextField: UITextField!
    @IBOutlet weak var pwCheckInputTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var pwLabel: UILabel!
    @IBOutlet weak var pwCheckLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var topAnchor: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    private let viewModel = RegisterViewModel()
    
    
    private var currentTextFieldBottom : CGFloat = 0.0
    
    
    override func viewWillAppear(_ animated: Bool) {
        // 키보드가 화면을 가리는 것을 처리하기 위한 노티피케이션 등록
        self.addKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        createView()
        input()
        output()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    @IBAction func backToInitialPage(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setDelegate(){
        nameInputTextField.delegate = self
        idInputTextField.delegate = self
        pwInputTextField.delegate = self
        pwCheckInputTextField.delegate = self
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
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.register)
            .disposed(by: disposeBag)
        
    }
    
    func output(){
        viewModel.output.register.subscribe(onNext:{ result in
            switch result{
            case .success :
                self.dismiss(animated: true, completion: nil)
            case .failure :
                break
            case.invalidName :
                self.nameLabel.textColor = .red
            case .validName :
                self.nameLabel.textColor = .black
            case .invalidId :
                self.idLabel.textColor = .red
            case .validId :
                self.idLabel.textColor = .black
            case .alreadyExists :
                self.idLabel.textColor = .red
                let customDialog = CustomDialog(width: 300, height: 150, type: .OK)
                customDialog.setTitleLabel(text: "이미 존재하는 아이디 입니다.")
                customDialog.show()
            case .invalidPassword :
                self.pwLabel.textColor = .red
            case .validPassword :
                self.pwLabel.textColor = .black
            case .invalidCheckPassword :
                self.pwCheckLabel.textColor = .red
            case .validCheckPassword :
                self.pwCheckLabel.textColor = .black
            case let .invalidInputRegister(term) :
                let customDialog = CustomDialog(width: 300, height: 200, type: .OK)
                customDialog.setTitleLabel(text: "잘못된 형식입니다.\n[\(term)]")
                customDialog.setSubtitleLabel(text: "다시 확인해 주세요.")
                customDialog.show()
            

            }
        }).disposed(by: disposeBag)
    }
}


extension RegisterViewController {
    
    func createView(){
        createNameInputTextField()
        createIdInputTextField()
        createPasswordInputTextField()
        createCheckPasswordInputTextField()
        
    }
    
    func createNameInputTextField(){
        nameInputTextField.placeholder = "이름을 입력하세요."
        nameInputTextField.keyboardType = .default
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        nameInputTextField.leftView = leftPadding
        nameInputTextField.leftViewMode = .always
    }
    
    
    func createIdInputTextField(){
        idInputTextField.placeholder = "아이디를 입력하세요."
        idInputTextField.keyboardType = .alphabet
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        idInputTextField.leftView = leftPadding
        idInputTextField.leftViewMode = .always
    }
    
    func createPasswordInputTextField(){
        pwInputTextField.placeholder = "비밀번호를 입력하세요."
        pwInputTextField.keyboardType = .default
        pwInputTextField.isSecureTextEntry = true
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        pwInputTextField.leftView = leftPadding
        pwInputTextField.leftViewMode = .always
    }
    
    func createCheckPasswordInputTextField(){
        pwCheckInputTextField.placeholder = "비밀번호를 다시 입력하세요."
        pwCheckInputTextField.keyboardType = .default
        pwCheckInputTextField.isSecureTextEntry = true
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        pwCheckInputTextField.leftView = leftPadding
        pwCheckInputTextField.leftViewMode = .always
    }
}

extension RegisterViewController {
    //화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //리턴키 눌렀을 떄 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 현재 선택된 텍스트 필드의 하단 y좌표 저장
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // textfield.frame은 이를 감싸는 슈퍼뷰의 좌표
        // 전체 view에 대한 좌표를 구해야 하므로 convert메서드 사용
        currentTextFieldBottom = view.convert(textField.frame,from : textField.superview ).maxY
    }
    
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에 알린다.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드가 사라질 때 앱에 알린다.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    // 키보드가 현재 텍스트필드를 가리는 만큼 올려주는 메서드
    @objc func keyboardWillShow(_ noti : NSNotification){
        
        if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let rect = frame.cgRectValue
            let keyboardY = rect.minY // 키보드 상단 좌표
            // 가리지 않는 경우
            if currentTextFieldBottom <= keyboardY - 10  {
                return
            }
            
            self.topAnchor.constant = 60 + (keyboardY - 10 - self.currentTextFieldBottom)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }

        }
    }
    
    // 원래 화면 높이로 돌아오는 메서드
    @objc func keyboardWillHide(_ noti : NSNotification){
        self.topAnchor.constant = 60
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
}
