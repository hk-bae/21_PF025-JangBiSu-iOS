//
//  UIKit+Extension.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import UIKit

extension UIViewController {
    
    var topPresentedViewController: UIViewController {
        var top = self
        while let newTop = top.presentedViewController { top = newTop }
        return top
    }
    
    var topVisibleController: UIViewController {
        let top = self.topPresentedViewController
        return top.navigationController?.viewControllers.last ?? top.children.last ?? top
    }
    
    static var visibleController: UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        return keyWindow?.rootViewController?.topVisibleController
    }
}


//자연스러운 팝업을 위한 클래스
class OverrappingViewController: UIViewController {
    
    final private var dimmedBackgroundColor: UIColor = .black
    final private var dimmedTiming = 0.3
    final var dimmedTimingDisclouse: Double?
    
    fileprivate var dimmedBackgroundView: UIView?
    
    
    //뷰 생성 직전
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //해당 뷰컨트롤러를 가져온다.
        guard let presentingViewController = presentingViewController ?? parent else {
            fatalError()
        }
        
        //뷰컨트롤러의 뷰의 바운드를 전체로 하는 뷰를 생성
        dimmedBackgroundView = UIView(frame: presentingViewController.view.bounds)
        //backgroundColor 지정
        dimmedBackgroundView!.backgroundColor = dimmedBackgroundColor
        //alpha 지정
        dimmedBackgroundView!.alpha = 0.0
        //superview 크기에 따라 자동 조정
        dimmedBackgroundView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        dimmedBackgroundView!.translatesAutoresizingMaskIntoConstraints = true
        //해당 뷰를 서브뷰로 추가
        presentingViewController.view.addSubview(dimmedBackgroundView!)
        //0.3초 후에 alpha를 0.5로 (반투명하게) 변경
        UIView.animate(withDuration: dimmedTiming, animations: { [weak self] in
            self?.dimmedBackgroundView!.alpha = 0.5
        })
    }
    
    //뷰 소멸 직전
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: dimmedTimingDisclouse ?? dimmedTiming, animations: { [weak self] in
            self?.dimmedBackgroundView!.alpha = 0.0 //dimmedBaackgroundView를 우선적으로 완전 투명하게 변경
        }, completion: { [weak self] _ in
            self?.dimmedBackgroundView!.removeFromSuperview() //완료 후 superview에서 제거
        })
    }
}

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
