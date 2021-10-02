//
//  MainViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/30.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var food11: ShadowingButton!
    @IBOutlet weak var food12: ShadowingButton!
    @IBOutlet weak var food13: ShadowingButton!
    @IBOutlet weak var food21: ShadowingButton!
    @IBOutlet weak var food22: ShadowingButton!
    @IBOutlet weak var food23: ShadowingButton!
    
    lazy var foods : [ShadowingButton] = [food11,food12,food13,food21,food22,food23]
    
    
    @IBOutlet weak var checkIceButton: UIButton!
    @IBOutlet weak var manageButton: UIButton!
    
    let viewModel = MainViewModel()
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        //         fetch Data
        viewModel.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        input()
        output()
        // foreground 진입 시 fetchData 호출
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
}

extension MainViewController{
    func input(){
        
        for (index,foodButton) in foods.enumerated() {
            foodButton.rx.tap.asObservable()
                .map({ index })
                .bind(to: viewModel.input.foodTouch)
                .disposed(by: disposeBag)
        }
        
        checkIceButton.rx.tap.asObservable()
            .subscribe(onNext:{
                if let viewController = self.storyboard?.instantiateViewController(identifier: "CheckIceVC") as? CheckIceViewController{
                    // ===========서버 통신을 통해 얼음이 얼었는지 가져오기===========
                    var isIceMade = false
                    viewController.isIceMade = isIceMade
                    self.present(viewController, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func output(){
        viewModel.output.foodTouch.asObservable()
            .subscribe(onNext:{ result in
                switch result{
                case .needToRegister(let index) :
                    self.popUpRegisterFoodVC(index: index)
                case .inquireResult(let index) :
                    if let viewController = self.storyboard?.instantiateViewController(identifier: "InquireFoodVC") as? InquireViewController{
                        viewController.food = self.viewModel.foods.value[index]
                        viewController.completion = { result in
                            
                            switch result{
                            case .modify:
                                //modify dialog 띄우기
                                self.popUpRegisterFoodVC(index: index,type: .modify)
                                break
                            case .ok: break
                            }
                        }
                        self.present(viewController,animated: true,completion: nil)
                    }
                    return
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.registerFood.asObservable()
            .subscribe(onNext:handleRegisterFoodResult)
            .disposed(by: disposeBag)
        
        viewModel.output.updateFoods.asObservable()
            .subscribe(onNext:updateFoods)
            .disposed(by: disposeBag)
    }
}

extension MainViewController {
    // 반찬 등록 결과 처리
    func handleRegisterFoodResult(_ result : MainViewModel.FoodRegisterResult){
        switch result {
        case .success :
            break
        case .failure(let errorMessage) :
            TTSUtility.speak(string: errorMessage)
        }
    }
    
    func popUpRegisterFoodVC(index:Int,type : RegisterFoodViewController.RegisterType = .register){
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "FoodRegisterVC") as? RegisterFoodViewController{
            switch type {
            case .register:
                viewController.completion = { foodName in
                    self.viewModel.input.registerFood.accept((index,foodName))
                }
            case .modify :
                viewController.type = type
                viewController.completion = { foodName in
                    self.viewModel.input.modifyFood.accept((index,foodName))
                }
            }
            self.present(viewController, animated: true, completion: nil)
            
        }
    }
    
    func updateFoods(){
        let updatedValues = viewModel.foods.value
        for (i,food) in updatedValues.enumerated() {
            foods[i].configureFoodButton(food: food)
        }
    }
    
    @objc func willEnterForeground(){
        viewModel.fetchData()
    }
}

extension MainViewController {
    func createViews(){
        createTitleLabel()
        createFoodsButton()
        createCheckIceButton()
        createManageButton()
        configureCornerRadius()
    }
    
    func createTitleLabel(){
        titleLabel.text = "\(UserInfo.savedUser?.id ?? "이름없음")님의 냉장고"
    }
    
    func createFoodsButton(){
        for foodButton in foods {
            foodButton.titleLabel?.numberOfLines = 0
            foodButton.layer.backgroundColor = UIColor.Service.foodGray.value.cgColor
            foodButton.setTitleColor(UIColor.Service.yellow.value, for: .normal)
            foodButton.layer.cornerRadius = 15
            foodButton.configureShadowColor(UIColor.Service.black.value)
            foodButton.titleLabel?.textAlignment = .center
        }
    }
    
    func createCheckIceButton(){
        checkIceButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
    }
    
    func createManageButton(){
        manageButton.setTitleColor(UIColor.Service.yellow.value, for: .normal)
    }
    
    func configureCornerRadius(){
        view.layoutIfNeeded()
        checkIceButton.layer.cornerRadius = checkIceButton.frame.height / 2.0
    }
}

extension ShadowingButton {
    func configureFoodButton(food : Food?){
        if let food = food {
            self.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
            self.setTitleColor(UIColor.black, for: .normal)
            self.setTitle(food.foodName, for: .normal)
        }else{
            self.layer.backgroundColor = UIColor.Service.foodGray.value.cgColor
            self.setTitleColor(UIColor.Service.yellow.value, for: .normal)
            self.setTitle("반찬\n등록", for: .normal)
        }
    }
}
