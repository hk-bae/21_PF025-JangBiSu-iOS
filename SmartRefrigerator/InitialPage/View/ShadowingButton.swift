//
//  RedButton.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/03.
//

import UIKit

@IBDesignable
class ShadowingButton : UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createView()
    }
}

extension ShadowingButton {
    func createView(){
//        self.setTitleColor(UIColor.Service.white100.value, for: .normal)
//        self.layer.backgroundColor = UIColor.Service.red.value.cgColor
//
//        self.layer.borderWidth = 2
//        self.layer.borderColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width:0,height:10)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
    
    func configureShadowColor(_ color : UIColor){
        self.layer.shadowColor = color.cgColor
    }

}
