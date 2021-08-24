//
//  ViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: CommonString.AUTO_LOGIN.rawValue), let _ = UserInfo.savedUser {
            // 자동로그인
//            let main = UIHostingController(rootView: MainView())
//            main.modalTransitionStyle = .crossDissolve
//            main.modalPresentationStyle = .overFullScreen
//            self.present(main, animated: true,completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}



