//
//  ViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import UIKit


class InitialViewController: UIViewController {
    
    @IBOutlet weak var moveToLoginPageButton: ShadowingButton!
    @IBOutlet weak var moveToRegisterPageButton: ShadowingButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        configureNavigationController()
        autoLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
}

extension InitialViewController {
    func createView(){
        createGradeint()
        createMoveToLoginButton()
        createMoveToRegisterButton()
        configureCornerRadius()
    }
    
    func configureNavigationController(){
        // 전체 네비게이션 바에 대해서 라인을 없앤다
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white, .font : UIFont.Service.notoSans_regular(_size: 20).value]
        
    }
    
    func createGradeint(){
        self.view.backgroundColor = UIColor.Service.white100.value
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [
            UIColor.Service.black.value.cgColor,
            UIColor.Service.darkGray.value.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.35, y: 0)
        gradient.endPoint = CGPoint(x: 0.65, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func createMoveToLoginButton(){
        
        moveToLoginPageButton.setTitleColor(UIColor.Service.yellow.value, for: .normal)
        moveToLoginPageButton.layer.backgroundColor = UIColor.Service.defaultBlack.value.cgColor
        
        
        moveToLoginPageButton.layer.borderWidth = 2
        moveToLoginPageButton.layer.borderColor = UIColor.Service.yellow.value.cgColor
        moveToLoginPageButton.layer.shadowColor = UIColor.Service.shadwGray.value.cgColor
        
    }
    
    func createMoveToRegisterButton(){
        moveToRegisterPageButton.setTitleColor(UIColor.Service.defaultBlack.value, for: .normal)
        moveToRegisterPageButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        moveToRegisterPageButton.layer.shadowColor = UIColor.Service.shadwGray.value.cgColor
    }
    
    func configureCornerRadius(){
        view.layoutIfNeeded()
        moveToRegisterPageButton.layer.cornerRadius = moveToRegisterPageButton.frame.height / 2.0
        moveToLoginPageButton.layer.cornerRadius = moveToLoginPageButton.frame.height / 2.0
    }
}

extension InitialViewController {
    func autoLogin(){
        if UserDefaults.standard.bool(forKey: CommonString.AUTO_LOGIN.rawValue), let _ = UserInfo.savedUser?.shelf {
            //자동로그인
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let main = mainStoryboard.instantiateViewController(identifier: "MainVC") as! MainViewController
            main.modalTransitionStyle = .crossDissolve
            main.modalPresentationStyle = .overFullScreen
            self.present(main, animated: true)
        }
    }
}
