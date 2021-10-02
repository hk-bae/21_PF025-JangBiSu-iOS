//
//  RegisterFoodViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/10/01.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterFoodViewController: OverrappingViewController,UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dimButton: UIButton!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foodNameTextField: InputTextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var completion : ((String) -> Void)?
    
    let viewModel = RegisterFoodViewModel()
    let disposeBag = DisposeBag()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .overFullScreen
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.roundCorners(cornerRadius: 15, byRoundingCorners: [.topLeft,.topRight])
        setDelegate()
        createView()
        addKeyboardNotifications()
        input()
        output()

    }
    
    func setDelegate(){
        foodNameTextField.delegate = self
    }
    
}

extension RegisterFoodViewController {
    func input(){
        submitButton.rx.tap.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.submit)
            .disposed(by: disposeBag)
        
        dimButton.rx.tap.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:cancel)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:cancel)
            .disposed(by: disposeBag)
        
        foodNameTextField.rx.text.orEmpty
            .bind(to: viewModel.input.foodNameInputTextField)
            .disposed(by: disposeBag)
        
        foodNameTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext:clearInputId)
            .disposed(by: disposeBag)
    }
    func output(){
        viewModel.output.submit.asObservable()
            .subscribe(onNext:{ [weak self] result in
                guard let self = self else {fatalError()}
                switch result {
                case .success(let name) :
                    self.removeKeyboardNotifications()
                    self.dismiss(animated: true) { [weak self] in
                        self?.completion?(name)
                    }
                    
                case .invalidInput :
                    TTSUtility.speak(string: "이름은 여섯자리 이하로 지정해주세요.")
                }
            })
            .disposed(by: disposeBag)
    }
}

extension RegisterFoodViewController {
    func cancel(){
        self.removeKeyboardNotifications()
        self.dismiss(animated: true)
    }
    
    func clearInputId(){
        self.foodNameTextField.text = ""
        self.viewModel.input.foodNameInputTextField.accept("")
    }
    

}



extension RegisterFoodViewController{
    func createView(){
        containerView.layer.backgroundColor = UIColor.Service.bottomSheetDialogGray.value.cgColor
        createTitleLabel()
        createFoodNameInputTextField()
        createDateLabel()
        createSubmitButton()
        createCancelButton()
        configureViews()
    }
    
    func createTitleLabel(){
        titleLabel.textColor = UIColor.Service.defaultWhite.value
    }
    
    
    func createFoodNameInputTextField(){
        foodNameTextField.setPlaceHolder("반찬 이름을 입력해 주세요.(6자리 이하)")
        foodNameTextField.keyboardType = .default
    }
    func createDateLabel(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy - MM - dd"
        let currentDateString = formatter.string(from: Date())
        print(currentDateString)
        dateLabel.text = "등록일 : \(currentDateString)"
    }
    
    func createCancelButton(){
        cancelButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        cancelButton.titleLabel?.textColor = UIColor.Service.defaultBlack.value
    }
    
    func createSubmitButton(){
        submitButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        submitButton.titleLabel?.textColor = UIColor.Service.defaultBlack.value
    }
    
    func configureViews(){
        view.layoutIfNeeded()
        submitButton.layer.cornerRadius = submitButton.frame.height / 2.0
        cancelButton.layer.cornerRadius =
            cancelButton.frame.height / 2.0
        foodNameTextField.initView()
    }
}


extension RegisterFoodViewController {
    //화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //리턴키 눌렀을 떄 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

    // 키보드 높이 만큼 화면 올리기
    @objc func keyboardWillShow(_ noti : NSNotification){

        if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let rect = frame.cgRectValue
            let keyboardHeight = rect.height

            self.keyboardHeightConstraint.constant = keyboardHeight

            view.layoutIfNeeded()

        }
    }

    // 원래 화면 높이로 돌아오는 메서드
    @objc func keyboardWillHide(_ noti : NSNotification){
        self.keyboardHeightConstraint.constant = 0
        view.layoutIfNeeded()
    }
}
