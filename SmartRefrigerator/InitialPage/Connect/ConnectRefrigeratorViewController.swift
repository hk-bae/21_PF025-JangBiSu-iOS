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
        }else{        navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

extension ConnectRefrigeratorViewController{
    func input(){
        nfcButton.rx.tap.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.nfcButton)
            .disposed(by: disposeBag)
        
        nfcIdInputButton.rx.tap.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NFCInputVC") as? ConnectRefrigeratorByNFCInputViewController{
                    viewController.completion = self.handleConnectResult
                    self.present(viewController, animated: true, completion: nil)
                }
                
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func output(){
        viewModel.output.connectRefrigerator
            .subscribe(onNext:handleConnectResult)
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
                if let navigationViewController = self.navigationController{
                    self.present(main, animated: true) {
                        navigationViewController.popViewController(animated: true)
                    }
                }else{
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
    
    
}
