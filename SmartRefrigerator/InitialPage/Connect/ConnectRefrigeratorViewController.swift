//
//  ConnectRefrigeratorViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/03.
//

import UIKit
import CoreNFC
import RxSwift
import RxCocoa

class ConnectRefrigeratorViewController : UIViewController{
    
    @IBOutlet weak var nfcButton: UIButton!
    @IBOutlet weak var nfcIdInputButton: UIButton!
    
    private let viewModel = ConnectRefrigeratorViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.Service.defaultBlack.value.cgColor
        createView()
        input()
        output()
    }
    
    @IBAction func backToInitalPage(_ sender: Any) {
        let vc = navigationController?.viewControllers[1]
        if let _ = vc as? LoginViewController {
            navigationController?.popViewController(animated: true)
        }else{
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

extension ConnectRefrigeratorViewController{
    func input(){
        nfcButton.rx.tap.asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.nfcButton)
            .disposed(by: disposeBag)
        
        nfcIdInputButton.rx.tap.asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] in
                guard let self = self else { return }
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NFCInputVC") as? ConnectRefrigeratorByNFCInputViewController{
                    viewController.completion = self.handleConnectResult
                    self.present(viewController, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func output(){
        viewModel.output.connectRefrigerator
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] result in
                self?.handleConnectResult(result: result)
            })
            .disposed(by: disposeBag)
    }
}

extension ConnectRefrigeratorViewController{
    func handleConnectResult(result : ConnectRefrigeratorViewModel.ConnectResult){
        switch result {
        case .success:
            if let _ = UserInfo.savedUser?.shelf {
                let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let main = mainStoryboard.instantiateViewController(identifier: "MainVC") as! MainViewController
                main.modalTransitionStyle = .crossDissolve
                main.modalPresentationStyle = .overFullScreen
                if let navigationViewController = self.navigationController{ // 로그인,회원가입 이후
                    self.present(main, animated: true) {
                        navigationViewController.popToRootViewController(animated: false)
                    }
                }else{ // NFC 재등록 이후
                    let presentingVC = presentingViewController
                    self.dismiss(animated: true) {
                        presentingVC?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        case .failure(let message) :
            print(message)
        }
    }
}

extension ConnectRefrigeratorViewController {
    
    func createView(){
        createNfcButton()
        createNfcIdButton()
        createBackButton()
    }
    
    func createNfcButton(){
        nfcButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        nfcButton.titleLabel?.textColor = UIColor.Service.defaultBlack.value
        nfcButton.layer.cornerRadius = 16
        nfcButton.titleLabel?.numberOfLines = 0
        nfcButton.titleLabel?.textAlignment = .center
    }
    
    func createNfcIdButton(){
        nfcIdInputButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        nfcIdInputButton.titleLabel?.textColor = UIColor.Service.defaultBlack.value
        nfcIdInputButton.layer.cornerRadius = 16
        nfcIdInputButton.titleLabel?.numberOfLines = 0
        nfcIdInputButton.titleLabel?.textAlignment = .center
    }
    
    // 선반 재등록인 경우 back 버튼 추가
    func createBackButton(){
        if let _ = self.navigationController { return }
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.accessibilityLabel = "뒤로가기"
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 28),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        ])
        
        backButton.rx.tap.asObservable()
            .subscribe(onNext:{ [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    
}
