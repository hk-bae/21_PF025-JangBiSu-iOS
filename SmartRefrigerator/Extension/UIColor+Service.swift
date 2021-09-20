//
//  UIColor+Service.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/31.
//

import UIKit

extension UIColor {
    enum Service {
        case black
        case defaultBlack
        case darkGray
        case borderGray
        case yellow
        case orange
        case white100
        case backgroundWhite
        case shadwGray
        case gray
        
        var value : UIColor {
            switch self {
            case .black :
                return UIColor(red: 8.0/255.0, green: 8.0/255.0, blue: 8.0/255.0, alpha: 1)
            case .defaultBlack :
                return UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1)
            case .darkGray :
                return UIColor(red: 53.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 1)
            case .borderGray :
                return UIColor(red: 104.0/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1)
            case .backgroundWhite :
                return UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1)
            case .yellow :
                return UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1)
            case .orange :
                return UIColor(red: 1, green: 136.0/255.0, blue: 0, alpha: 1)
            case .white100 :
                return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            case .shadwGray :
                return UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 0.3)
            case .gray :
                return UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
            }
        }
        
    }
}
