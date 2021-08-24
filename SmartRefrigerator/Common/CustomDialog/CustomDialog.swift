//
//  CustomDialog.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/24.
//

import UIKit


extension CustomDialog {
    func show(target : UIViewController? = nil) {
        guard let parent = target ?? UIViewController.visibleController else {
            return
        }
        parent.present(self, animated: true, completion: nil)
    }
}

final class CustomDialog : OverrappingViewController {
    
    var onClickAction : ((ContentView.Action) -> Void)?
    var width,height : CGFloat
    var type : CustomDialogType

    private lazy var contentView : ContentView = {
       let contentView = ContentView()
        contentView.backgroundColor = .white
        contentView.roundCorners(cornerRadius: 17, byRoundingCorners: [.topLeft,.topRight,.bottomLeft,.bottomRight])
        contentView.onAction = { [weak self] action in
            guard let self = self else { return }
            self.onClickAction?(action)
            self.dismiss(animated: true, completion: nil)
        }
        return contentView
    }()
    
    init(width:CGFloat,height:CGFloat,type:CustomDialogType){
        self.width = width
        self.height = height
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: height),
            contentView.widthAnchor.constraint(equalToConstant: width),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        contentView.createViews()
        switch type {
        case .OK_CANCEL:
            contentView.createOkButton()
            contentView.createCloseButton()
        case .OK:
            contentView.createLargeOkButton()
        }
       
    }

}

extension CustomDialog {
    enum CustomDialogType{
        case OK_CANCEL
        case OK
    }
    
    func setTitleLabel(text:String){
        contentView.setTitleLabel(text)
    }
    
    func setSubtitleLabel(text:String){
        contentView.setSubtitleLabel(text)
    }
    
    func setOkButtonText(text:String){
        switch type {
        case .OK_CANCEL :
            contentView.setOkButton(text)
        case .OK :
            contentView.setLargeOkButton(text)
        }
    }
    
    func setCloseButtonText(text:String){
        contentView.setCancelButton(text)
    }
}


extension CustomDialog{
    final class ContentView : UIView{
        
        enum Action {
            case onClickClose
            case onClickOK
        }
        
        // close, OK에 따라서 다른 동작 제공
        var onAction : ((Action) -> Void)?
        
        private lazy var titleLabel = UILabel()
        private lazy var subtitleLabel = UILabel()
        
        private lazy var okButton = UIButton()
        private lazy var closeButton = UIButton()
        
        private lazy var largeOkButton = UIButton()
        
        
        init(){
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func createViews(){
            layoutIfNeeded()
            createTitleLabel()
            createSubtitleLabel()
        }
    }


}

private extension CustomDialog.ContentView {
    func createTitleLabel(){
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont.systemFont(ofSize: 18,weight: .semibold)

        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: frame.height / 8)
        ])

    }
    func createSubtitleLabel(){
    
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.textColor = .black
        subtitleLabel.font = UIFont.systemFont(ofSize: 13,weight: .regular)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
    
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    
    func createOkButton(){
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitleColor(.white, for: .normal)
        okButton.setTitle("확인", for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 13,weight: .medium)
        okButton.layer.backgroundColor = UIColor.black.cgColor
        okButton.addTarget(self, action: #selector(onClickSubmit(_:)), for: .touchUpInside)
        addSubview(okButton)
        
        NSLayoutConstraint.activate([
            okButton.widthAnchor.constraint(equalToConstant: frame.width * 0.38),
            okButton.heightAnchor.constraint(equalToConstant: 50),
            okButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -frame.height / 10),
            okButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: frame.width * 0.1)
        ])
        
        okButton.layer.cornerRadius = 16
    }
    
    
    func createCloseButton(){
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("취소", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13,weight: .medium)
        closeButton.layer.backgroundColor = UIColor.black.cgColor
        closeButton.addTarget(self, action: #selector(onClickClose(_:)), for: .touchUpInside)
        
        addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: okButton.bottomAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -frame.width * 0.1),
            closeButton.widthAnchor.constraint(equalTo: okButton.widthAnchor),
            closeButton.heightAnchor.constraint(equalTo: okButton.heightAnchor)
        ])
        
        closeButton.layer.cornerRadius = 16
    }
    
    func createLargeOkButton(){
        largeOkButton.translatesAutoresizingMaskIntoConstraints = false
        largeOkButton.setTitle("확인", for: .normal)
        largeOkButton.setTitleColor(.white, for: .normal)
        largeOkButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        largeOkButton.layer.backgroundColor = UIColor.black.cgColor
        largeOkButton.addTarget(self, action: #selector(onClickSubmit(_:)), for: .touchUpInside)
        largeOkButton.layer.cornerRadius = 16
        addSubview(largeOkButton)
        
        NSLayoutConstraint.activate([
            largeOkButton.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.8),
            largeOkButton.heightAnchor.constraint(equalToConstant: 50),
            largeOkButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -frame.height / 10),
            largeOkButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

private extension CustomDialog.ContentView {
    func setTitleLabel(_ title : String){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.33
        titleLabel.attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.textAlignment = .center
        
    }
    func setSubtitleLabel(_ title: String){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.33
        subtitleLabel.attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    func setOkButton(_ title: String){
        okButton.titleLabel?.text = title
    }
    
    func setCancelButton(_ title: String){
        closeButton.titleLabel?.text = title
    }
    
    func setLargeOkButton(_ title: String){
        largeOkButton.titleLabel?.text = title
    }

}


private extension CustomDialog.ContentView {
    
    @objc func onClickCloseImg(_ gesture : UITapGestureRecognizer){
        onAction?(.onClickClose)
    }
    
    @objc func onClickClose(_ any : Any){
        onAction?(.onClickClose)
    }
    
    @objc func onClickSubmit(_ any: Any){
        onAction?(.onClickOK)
    }
}
