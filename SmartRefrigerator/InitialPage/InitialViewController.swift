//
//  ViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import UIKit
import SwiftUI
class InitialViewController: UIViewController {
    
    @IBOutlet weak var moveToLoginPageButton: UIButton!
    @IBOutlet weak var moveToRegisterPageButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: CommonString.AUTO_LOGIN.rawValue), let _ = UserInfo.savedUser {
            // 자동로그인
            //            let main = UIHostingController(rootView: MainView())
            //            main.modalTransitionStyle = .crossDissolve
            //            main.modalPresentationStyle = .overFullScreen
            //            self.present(main, animated: true,completion: nil)
        }
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // 개발 중 임시용
    @IBAction func moveToMainPage(_ sender: Any) {
        let main = UIHostingController(rootView: MainView())
        main.modalTransitionStyle = .crossDissolve
        main.modalPresentationStyle = .overFullScreen
        self.present(main, animated: true,completion: nil)
    }
}

extension InitialViewController {
    func createView(){
        createGradeint()
        createMoveToLoginButton()
        createMoveToRegisterButton()
    }
    
    func createGradeint(){
        self.view.backgroundColor = UIColor.Service.white100.value
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [
            UIColor.Service.orange.value.cgColor,
            UIColor.Service.yellow.value.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.35, y: 0)
        gradient.endPoint = CGPoint(x: 0.65, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func createMoveToLoginButton(){
        
        moveToLoginPageButton.setTitleColor(UIColor.Service.red.value, for: .normal)

        moveToLoginPageButton.layer.cornerRadius = moveToLoginPageButton.frame.height / 2.0
        moveToLoginPageButton.layer.backgroundColor = UIColor.Service.white100.value.cgColor
        
        moveToLoginPageButton.layer.borderWidth = 2
        moveToLoginPageButton.layer.borderColor = UIColor.red.cgColor
        
        moveToLoginPageButton.layer.shadowColor = UIColor.Service.red.value.cgColor
        moveToLoginPageButton.layer.shadowOffset = CGSize(width:0,height:5)
        moveToLoginPageButton.layer.shadowOpacity = 0.2
        moveToLoginPageButton.layer.shadowRadius = 5
        moveToLoginPageButton.layer.masksToBounds = false
        
        
        
    }
    
    func createMoveToRegisterButton(){
        
        moveToRegisterPageButton.setTitleColor(UIColor.Service.white100.value, for: .normal)
        moveToRegisterPageButton.layer.cornerRadius = moveToRegisterPageButton.frame.height / 2.0
        moveToRegisterPageButton.layer.backgroundColor = UIColor.Service.red.value.cgColor
        
        moveToRegisterPageButton.layer.borderWidth = 2
        moveToRegisterPageButton.layer.borderColor = UIColor.red.cgColor
        
        moveToRegisterPageButton.layer.shadowColor = UIColor.Service.red.value.cgColor
        moveToRegisterPageButton.layer.shadowOffset = CGSize(width:0,height:5)
        moveToRegisterPageButton.layer.shadowOpacity = 0.2
        moveToRegisterPageButton.layer.shadowRadius = 5
        moveToRegisterPageButton.layer.masksToBounds = false
    }
}


