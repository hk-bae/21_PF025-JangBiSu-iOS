//
//  ConnectRefrigeratorViewController.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/03.
//

import UIKit
import CoreNFC

class ConnectRefrigeratorViewController : UIViewController{
    
    var detectedMessages = [NFCNDEFMessage]()
    var session : NFCNDEFReaderSession?
    
    override func viewDidLoad(){
        view.backgroundColor = UIColor.Service.backgroundWhite.value
        super.viewDidLoad()
    }
    
    @IBAction func backToInitalPage(_ sender: Any) {
        let vc = navigationController?.viewControllers[1]
        if let _ = vc as? LoginViewController {
            navigationController?.popViewController(animated: true)
        }else{        navigationController?.popToRootViewController(animated: true)
        }
    }
    @IBAction func test(_ sender: Any) {
        beginScanning()
    }
}

// NFC 통신 관련
extension ConnectRefrigeratorViewController : NFCNDEFReaderSessionDelegate {
    
    
    func beginScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            // NFC 태그를 지원하지 않는 기기일 경우 알림창!
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        // session 초기화
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        // 사용자에게 보여줄 메세지
        session?.alertMessage = "Hold your iPhone near the item to learn more about it."
        // 태그 스캔을 시작
        session?.begin()
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // 유효하지 않은 에러인지 옵셔널 바인딩으로 확인
        if let readerError = error as? NFCReaderError {
            // 위에서 설명한 두가지 에러( 태그는 성공적으로 읽었으나 유효하지 않은 정보, 사용자가 취소 또는 invalidate() 호출)
            // 이외의 에러에 대해서는 경고창을 띄워준다.
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "Session Invalidated",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // NDEF 메세지를 읽는 처리 담당
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        self.detectedMessages.append(contentsOf: messages)
    }
    
    
}
