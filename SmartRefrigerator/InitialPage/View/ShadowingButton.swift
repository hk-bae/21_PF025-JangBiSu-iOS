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
        
        self.layer.shadowOffset = CGSize(width:0,height:8)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
    
    func configureShadowColor(_ color : UIColor){
        self.layer.shadowColor = color.cgColor
    }

}
