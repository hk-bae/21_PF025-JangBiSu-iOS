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
        navigationController?.popToRootViewController(animated: true)
    }
}
