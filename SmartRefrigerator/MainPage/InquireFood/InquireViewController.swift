//
//  InquireViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/10/02.
//

import UIKit
import RxSwift

class InquireViewController : OverrappingViewController{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var foodNameButton: ShadowingButton!
    @IBOutlet weak var remainedWeightButton: ShadowingButton!
    @IBOutlet weak var registeredDateButton: ShadowingButton!
    
    @IBOutlet weak var ddayInfoLabel: UILabel!
    
    @IBOutlet weak var modifyButton: ShadowingButton!
    @IBOutlet weak var okButton: ShadowingButton!
    
    var completion : ((InquireResult) -> Void)?
    var food : Food!
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
        createViews()
    }
    
}

extension InquireViewController {
    enum InquireResult{
        case modify
        case ok
    }
}

extension InquireViewController {
    
    func createViews(){
        createContainerView()
        createTitleLabel()
        createFoodNameButton()
        createRemainedWeightButton()
        createRegisteredDateButton()
        createDdayInfoLabel()
        createModifyButton()
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
    
    func createFoodNameButton(){
        foodNameButton.layer.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1).cgColor
        foodNameButton.configureShadowColor(.black)
        var foodName = food.foodName
        let array = foodName.components(separatedBy: "\n")
        foodName = ""
        for word in array{
            foodName.append(word)
        }
        foodNameButton.setTitle(foodName, for: .normal)
    }
    
    func createRemainedWeightButton(){
        remainedWeightButton.layer.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1).cgColor
        remainedWeightButton.configureShadowColor(.black)
        remainedWeightButton.setTitle("잔여량 \(food.foodWeight)g", for: .normal)
        
    }
    
    func createRegisteredDateButton(){
        registeredDateButton.layer.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1).cgColor
        registeredDateButton.configureShadowColor(.black)
        registeredDateButton.setTitle(food.registeredDate, for: .normal)
    }
    
    func createDdayInfoLabel(){
        ddayInfoLabel.textColor = UIColor.Service.yellow.value
        ddayInfoLabel.text = "등록일로부터 \(food.afterRegisteredDate)일 지났습니다."
    }
    
    func createModifyButton(){
        modifyButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        modifyButton.configureShadowColor(.black)
        modifyButton.rx.tap.asObservable()
            .subscribe(onNext:{ _ in
                self.dismiss(animated: true) { [weak self] in
                    self?.completion?(.modify)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func createOkButton(){
        okButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        okButton.configureShadowColor(.black)
        okButton.rx.tap.asObservable()
            .subscribe(onNext:{ _ in
                self.dismiss(animated: true) { [weak self] in
                    self?.completion?(.ok)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func configureViews(){
        view.layoutIfNeeded()
        foodNameButton.layer.cornerRadius = foodNameButton.frame.height / 2.0
        remainedWeightButton.layer.cornerRadius =
            remainedWeightButton.frame.height / 2.0
        registeredDateButton.layer.cornerRadius = registeredDateButton.frame.height / 2.0
        
        okButton.layer.cornerRadius = okButton.frame.height / 2.0
        modifyButton.layer.cornerRadius =
            modifyButton.frame.height / 2.0
        
    }
    
}
