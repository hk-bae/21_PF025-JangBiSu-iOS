//
//  ConnectRefrigeratorViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/03.
//

import UIKit


class ConnectRefrigeratorViewController : UIViewController{
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    @IBAction func backToInitalPage(_ sender: Any) {
        let vc = navigationController?.viewControllers[1]
        if let _ = vc as? LoginViewController {
            navigationController?.popViewController(animated: true)
        }else{        navigationController?.popToRootViewController(animated: true)
        }
    }
}
