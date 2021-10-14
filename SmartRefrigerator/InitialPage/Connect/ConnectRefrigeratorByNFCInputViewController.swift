//
//  InputShelfIdViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/20.
//

import UIKit
import RxSwift
import RxCocoa

//extension ConnectRefrigeratorByNFCInputViewController {
//    func show(target : UIViewController? = nil) {
//        guard let parent = target ?? UIViewController.visibleController else {
//            return
//        }
//        parent.present(self, animated: true, completion: nil)
//    }
//}

class ConnectRefrigeratorByNFCInputViewController: OverrappingViewController, UITextFieldDelegate {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var cancelButton: ShadowingButton!
    @IBOutlet weak var submitButton: ShadowingButton!
    
    @IBOutlet weak var shelfIdInputTextField: InputTextField!
    
    @IBOutlet weak var keyBoardHeightConstraint: NSLayoutConstraint!
    var completion : ((ConnectRefrigeratorViewModel.ConnectResult) -> Void)?
    
    let viewModel = ConnectRefrigeratorByNFCInputViewModel()
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
        view.backgroundColor = .clear
        containerView.roundCorners(cornerRadius: 15, byRoundingCorners: [.topLeft,.topRight])
        setDelegate()
        addKeyboardNotifications()
        createView()
        input()
        output()
    }
    
    
    func setDelegate(){
        shelfIdInputTextField.delegate = self
    }
    
    deinit {
        print("deinit")
    }
}

extension ConnectRefrigeratorByNFCInputViewController{
    func input(){
        submitButton.rx.tap.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.submit)
            .disposed(by: disposeBag)
        
        
        cancelButton.rx.tap.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:cancel)
            .disposed(by: disposeBag)
        
        shelfIdInputTextField.rx.text.orEmpty
            .bind(to: viewModel.input.shelfIdInputTextField)
            .disposed(by: disposeBag)
        
        shelfIdInputTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext:clearInputId)
            .disposed(by: disposeBag)
    }
    
    func output(){
        viewModel.output.submit.asObservable()
            .subscribe(onNext:{ [weak self] result in
                guard let self = self else {fatalError()}
                switch result {
                case .success :
                    self.removeKeyboardNotifications()
                    self.dismiss(animated: true) { [weak self] in
                        self?.completion?(result)
                    }
                    
                case .failure(_) :
                    self.configureWrongNFCInput()
                }
            })
            .disposed(by: disposeBag)
        
    }
}

extension ConnectRefrigeratorByNFCInputViewController{
    func createView(){
        containerView.layer.backgroundColor = UIColor.Service.bottomSheetDialogGray.value.cgColor
        createTitleLabel()
        createShelfIdInputTextField()
        createSubtitleLabel()
        createCancelButton()
        createSubtitleLabel()
        configureViews()
    }

    
    func createTitleLabel(){
        titleLabel.textColor = UIColor.Service.defaultWhite.value
    }
    
    func createSubtitleLabel(){
        subtitleLabel.textColor = UIColor.Service.defaultWhite.value
    }
    
    func createShelfIdInputTextField(){
        shelfIdInputTextField.setPlaceHolder("고유번호를 입력해 주세요.")
        shelfIdInputTextField.keyboardType = .default
    }
    
    func createCancelButton(){
        cancelButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        cancelButton.titleLabel?.textColor = UIColor.Service.defaultBlack.value
        cancelButton.configureShadowColor(.black)
    }
    
    func createSubmitButton(){
        submitButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        submitButton.titleLabel?.textColor = UIColor.Service.defaultBlack.value
        submitButton.configureShadowColor(.black)
    }
    
    func configureViews(){
        view.layoutIfNeeded()
        submitButton.layer.cornerRadius = submitButton.frame.height / 2.0
        cancelButton.layer.cornerRadius =
            cancelButton.frame.height / 2.0
        shelfIdInputTextField.initView()
        
        // 폰트 크기 조정
        let currentFontName = subtitleLabel.font.fontName
        var currentFontSize = CGFloat(18)
        while subtitleLabel.frame.maxX >= containerView.bounds.maxX {
            currentFontSize -= 1
            subtitleLabel.font = UIFont(name: currentFontName, size: currentFontSize)
            subtitleLabel.layoutIfNeeded()
        }
            
    }

}

extension ConnectRefrigeratorByNFCInputViewController{
    func cancel(){
//        self.completion?(.failure(message: "cancel"))
        self.removeKeyboardNotifications()
        self.dismiss(animated: true)
    }
    
    func clearInputId(){
        self.shelfIdInputTextField.text = ""
        self.viewModel.input.shelfIdInputTextField.accept("")
    }
    
    func configureWrongNFCInput(){
        subtitleLabel.text = "고유번호가 일치하지 않습니다."
        TTSUtility.speak(string: subtitleLabel.text!)
        subtitleLabel.textColor = UIColor.Service.orange.value
        shelfIdInputTextField.configureView(true)
    }
}

extension ConnectRefrigeratorByNFCInputViewController {
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

            self.keyBoardHeightConstraint.constant = keyboardHeight

            view.layoutIfNeeded()

        }
    }

    // 원래 화면 높이로 돌아오는 메서드
    @objc func keyboardWillHide(_ noti : NSNotification){
        self.keyBoardHeightConstraint.constant = 0
        view.layoutIfNeeded()
    }
}
