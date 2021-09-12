//
//  UIKit+Extension.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import UIKit

extension UIView {
    
    //모서리 둥글게
    func roundCorners(cornerRadius: CGFloat, byRoundingCorners: UIRectCorner) {
        //iOS 11 이상
        if #available(iOS 11.0, *) {
            //테두리 기준 텍스트 자르기
            clipsToBounds = true
            //전달받은 cornerRadius 설정
            layer.cornerRadius = cornerRadius
            //설정된 위치의 모서리
            layer.maskedCorners = CACornerMask(rawValue: byRoundingCorners.rawValue)
        }else {
            //iOS 11 미만
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: byRoundingCorners,
                                    cornerRadii: CGSize(width:cornerRadius, height: cornerRadius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            
            layer.mask = maskLayer
        }
    }
}
