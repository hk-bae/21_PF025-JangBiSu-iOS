//
//  AlertMessageViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/10/03.
//

import UIKit

extension AlertMessageViewController{
    enum NFCAlertMessageResult{
        case continueNFC
        case cancel
    }
}

class AlertMessageViewController: OverrappingViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: ShadowingButton!
    @IBOutlet weak var nfcButton: ShadowingButton!
    
    var completion: ((NFCAlertMessageResult) -> Void)?
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    @IBAction func cacnel(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { fatalError()}
            self.completion?(.cancel)
        }
    }
    @IBAction func nfc(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in 
            guard let self = self else { fatalError()}
            self.completion?(.continueNFC)
        }
        
    }
    
}

extension AlertMessageViewController {
    func createView(){
        createContainerView()
        createCancelButton()
        createNFCButton()
        configureViews()
    }
    
    func createContainerView(){
        containerView.layer.backgroundColor = UIColor.Service.bottomSheetDialogGray.value.cgColor
        containerView.layer.cornerRadius = 15
    }
    
    func createCancelButton(){
        cancelButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        cancelButton.configureShadowColor(.black)
    }
    
    func createNFCButton(){
        nfcButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        nfcButton.configureShadowColor(.black)
    }
    
    func configureViews(){
        view.layoutIfNeeded()
        nfcButton.layer.cornerRadius = nfcButton.frame.height / 2.0
        cancelButton.layer.cornerRadius =
            cancelButton.frame.height / 2.0
    }
}


