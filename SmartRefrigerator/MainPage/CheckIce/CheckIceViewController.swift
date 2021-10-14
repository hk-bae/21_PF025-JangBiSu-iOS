//
//  CheckIceViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/10/02.
//

import UIKit
import RxSwift

class CheckIceViewController: OverrappingViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iceImageview: UIImageView!
    @IBOutlet weak var okButton: ShadowingButton!
    
    var isIceMade : Bool = false
    var image : UIImage {
        var image : UIImage
        if isIceMade{
            image = UIImage(named: "ice_filled")!
        }else{
            image = UIImage(named: "ice")!
        }
        return image
    }
    let disposeBag = DisposeBag()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
}

extension CheckIceViewController{
    
    func createView(){
        createContainerView()
        createTitleLabel()
        createIceImageView()
        createDescriptionLabel()
        createOkButton()
        configureViews()
        
    }
    
    func createContainerView(){
        containerView.roundCorners(cornerRadius: 15, byRoundingCorners: [.topLeft,.topRight])
        containerView.layer.backgroundColor = UIColor.Service.bottomSheetDialogGray.value.cgColor
    }
    
    func createTitleLabel(){
        titleLabel.textColor = UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1)
    }
    func createIceImageView(){
        iceImageview.image = self.image
    }
    
    func createDescriptionLabel(){
        if isIceMade {
            titleLabel.accessibilityLabel = "얼음 상태 확인\n얼음이 완성되었습니다."
            descriptionLabel.text = "얼음이 완성되었습니다."
        }else{
            descriptionLabel.text = "얼음을 생성 중 입니다."
            titleLabel.accessibilityLabel = "얼음 상태 확인\n얼음을 생성 중 입니다."
        }
    }
    
    func createOkButton(){
        okButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        okButton.setTitleColor(UIColor.Service.defaultBlack.value, for: .normal)
        okButton.configureShadowColor(.black)
        okButton.rx.tap.asObservable()
            .subscribe (onNext:{ _ in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
    }
    
    func configureViews(){
        view.layoutIfNeeded()
        okButton.layer.cornerRadius = okButton.frame.height / 2.0
        
    }
}
