//
//  ManageAccountViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/10/02.
//

import UIKit
import RxSwift
import RxCocoa

class ManageAccountViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var logoutButton: ShadowingButton!
    @IBOutlet weak var nfcButton: ShadowingButton!
    
    let viewModel = ManageAccountViewModel()
    let disposeBag = DisposeBag()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        input()
        output()
        
    }
    
    
}

extension ManageAccountViewController{
    func input(){
        nfcButton.rx.tap.asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.nfcButton)
            .disposed(by: disposeBag)
        
        backButton.rx.tap.asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.backButton)
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap.asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.logoutButton)
            .disposed(by: disposeBag)
    }
    
    func output(){
        viewModel.output.result.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{[weak self] result in
                self?.handleResult(result)
            }).disposed(by: disposeBag)
    }
}

extension ManageAccountViewController{
    func handleResult(_ result : ManageAccountViewModel.ButtonClickResult){
        switch result{
        case .back:
            self.dismiss(animated: true, completion: nil)
        case .logout:
            UserDefaults.standard.set(false,forKey: CommonString.AUTO_LOGIN.rawValue)
            guard let pvc = self.presentingViewController else { return}
            self.dismiss(animated: true) {
                pvc.dismiss(animated: true, completion: nil)
            }
            break
        case .nfc:
            guard let alertVC = self.storyboard?.instantiateViewController(identifier: "AlertMesageVC") as? AlertMessageViewController else { fatalError() }
            alertVC.completion = { result in
                switch result{
                case .continueNFC :
                    let storyboard = UIStoryboard.init(name: "Initial", bundle: nil)
                    guard let connectVC = storyboard.instantiateViewController(identifier: "connectVC") as? ConnectRefrigeratorViewController else { fatalError() }
                    connectVC.modalTransitionStyle = .crossDissolve
                    connectVC.modalPresentationStyle = .overFullScreen
                    self.present(connectVC, animated: true,completion: nil)
                case .cancel :
                    break
                }
            }
            self.present(alertVC, animated: true, completion: nil)
            break
        }
    }
}

extension ManageAccountViewController {
    func createView(){
        createBackButton()
        createNFCButton()
        createLogoutButton()
        configureViews()
    }
    
    func createBackButton(){
        backButton.accessibilityLabel = "뒤로가기"
    }
    func createLogoutButton(){
        logoutButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        logoutButton.configureShadowColor(.black)
    }
    func createNFCButton(){
        nfcButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        nfcButton.configureShadowColor(.black)
    }
    
    func configureViews(){
        view.layoutIfNeeded()
        logoutButton.layer.cornerRadius = logoutButton.frame.height / 2.0
        
        nfcButton.layer.cornerRadius = logoutButton.frame.height / 2.0
    }
}
