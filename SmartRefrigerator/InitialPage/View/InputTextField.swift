//
//  InputTextField.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/03.
//

import UIKit

@IBDesignable
class InputTextField : UITextField {
    
    var clearButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createView()
    }
}

extension InputTextField {
    func createView(){
        self.leftView = UIView()
        self.leftViewMode = .always
        
        let rightPadding = UIView()
        clearButton.setBackgroundImage(UIImage(named: "clear"), for: .normal)
        rightPadding.addSubview(clearButton)
        
        self.rightView = rightPadding
        self.rightViewMode = .always
        
        self.layer.borderColor = UIColor.Service.borderGray.value.cgColor
        self.layer.borderWidth = 2
        
        self.layer.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
        
        
    }
    
    func initView(){
        let leftPaddingSize = self.frame.width * 20.0 / 330.0
        self.leftView?.frame = CGRect(x: 0, y: 0, width: leftPaddingSize, height: 0)
        
        let rightPaddingSize = self.frame.width * 36.0 / 330.0
        self.rightView?.frame = CGRect(x: 0, y: 0, width: rightPaddingSize, height: self.frame.height)
        
        let buttonSize = self.frame.width * 16.0 / 330.0
        self.clearButton.frame = CGRect(x: 0, y: self.rightView!.frame.height / 2.0 - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        
        self.layer.cornerRadius = self.frame.height / 2.0
    }
    
    
    func configureView(isWrong : Bool){
        if isWrong {
            self.layer.borderColor = UIColor.Service.orange.value.cgColor
        }else{
            self.layer.borderColor = UIColor.Service.borderGray.value.cgColor
        }
    }
    
    func setPlaceHolder(_ text:String){
        self.attributedPlaceholder = NSAttributedString(string: text,attributes: [NSAttributedString.Key.foregroundColor: UIColor.Service.gray.value,NSAttributedString.Key.font: UIFont.Service.notoSans_regular(_size: 14).value])
    }
    
    func configureAccessibilityLabel(_ text:String){
        clearButton.accessibilityLabel = "\(text) 입력 내용 초기화"
    }
}
