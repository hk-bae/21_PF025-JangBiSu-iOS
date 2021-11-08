//
//  ViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import UIKit


class InitialViewController: UIViewController,BluetoothSerialDelegate {
    
    @IBOutlet weak var moveToLoginPageButton: ShadowingButton!
    @IBOutlet weak var moveToRegisterPageButton: ShadowingButton!
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationController()
        autoLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BluetoothSerial.shared.delegate = self
        requestNotificationAuthorization()
        createView()
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
        // 전체 네비게이션 바의 백그라운드 이미지, 라인 등을 제거
        // 네비게이션 바의 텍스트 폰트 크기, 색상 지정
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white, .font : UIFont.Service.notoSans_regular(_size: 20).value]
        
    }
    
    func createGradeint(){
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
    
    // 알림 권한 허용 요청
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    
}
