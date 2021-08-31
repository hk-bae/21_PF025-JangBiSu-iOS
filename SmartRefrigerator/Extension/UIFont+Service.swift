//
//  UIFont+Service.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/31.
//

import UIKit
extension UIFont {
    enum Service {
        case nanumSquare_extraBold(_ size:CGFloat)
        case notoSans_bold(_ size:CGFloat)
        case notoSans_medium(_ size:CGFloat)
        case notoSans_regular(_size:CGFloat)
        
        var value: UIFont {
            switch self {
            case .nanumSquare_extraBold(let size) : return UIFont(name: self.fontName, size: size) ??
                UIFont.systemFont(ofSize: size)
            case .notoSans_bold(let size): return UIFont(name: self.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
            case .notoSans_medium(let size): return UIFont(name: self.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
            case .notoSans_regular(let size): return UIFont(name: self.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
            }
        }
        
        var fontName: String {
            switch self {
            case .nanumSquare_extraBold : return "NanumSquareOTF-ExtraBold"
            case .notoSans_bold: return "NotoSansCJkr-Bold"
            case .notoSans_medium: return "NotoSansCJkr-Medium"
            case .notoSans_regular: return "NotoSansCJkr-Regular"
            }
        }
    }
}
