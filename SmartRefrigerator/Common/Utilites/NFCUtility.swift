//
//  NFCUtility.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/03.
//

import CoreNFC
import Foundation

typealias nfcIdReadingCompletion = (Result<String,Error>) -> Void

enum NFCError : LocalizedError {
    case unavailable
    case invalidated(message: String)
    
    var errorDescription: String?{
        switch self {
        case .unavailable:
            return "NFC Reader Not Available"
        case let .invalidated(message) :
            return message
        }
    }
}

class NFCUtility : NSObject {
    
    enum Kind{
        case shelf
        case food
    }
    
    enum NFCAction {
        case readNFCIdentifier(kindOf:Kind)
        
        var alertMessage : String {
            switch self {
            case .readNFCIdentifier(let kind):
                if kind == Kind.shelf {
                    return "선반 태그 스티커 위에 핸드폰을 접촉해 주세요."
                }
                return "반찬통 태그 스티커 위에 핸드폰을 접촉해 주세요."
            }
        }
    }
    
    private static let shared = NFCUtility()
    private var action : NFCAction?
    
    private var session : NFCTagReaderSession?
    private var completion : nfcIdReadingCompletion?
    
    static func performAction(
        _ action : NFCAction,
        completion : nfcIdReadingCompletion? = nil
    ){
        guard NFCNDEFReaderSession.readingAvailable else {
            completion?(.failure(NFCError.unavailable))
            print("NFC is not available on ths device")
            return
        }
        
        
        
        shared.action = action
        shared.completion = completion
        
        shared.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: shared.self)
        shared.session?.alertMessage = action.alertMessage
        shared.session?.begin()
        
    }
}

extension NFCUtility : NFCTagReaderSessionDelegate {
    
    // 에러가 발생 했을 때 handlig
    func handleError(_ error: Error){
        // 세션의 alrert message를 설정
        session?.alertMessage = error.localizedDescription
        // 세션 무효화
        session?.invalidate()
    }
    
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // not used
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // 태그는 성공적으로 읽었는데 유효하지 않는 정보이거나
        // 사용자가 취소를 하거나 invalidate를 호출하는 경우를 제외하고는 NFCError를 전달한다.
        if let error = error as? NFCReaderError, error.code != .readerSessionInvalidationErrorFirstNDEFTagRead &&
            error.code != .readerSessionInvalidationErrorUserCanceled {
            completion?(.failure(NFCError.invalidated(message: error.localizedDescription)))
        }
        
        self.session = nil
        completion = nil
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        // 태그가 여러 개가 동시에 태깅된 경우 세션을 재시작할 수 있도록 한다.
        guard let tag = tags.first, tags.count == 1 else {
            session.alertMessage = "둘 이상의 태그가 감지됩니다.\n다시 시도해 주세요."
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)) {
                session.restartPolling()
            }
            return
        }
        
        // 1 : 현재 NFCNDEFReaderSession으로 탐지된 태그를 연결한다.
        session.connect(to: tag) { error in
            if let error = error {
                self.handleError(error)
                return
            }
            
            // 2 : 태그의 uid를 확인
            if case let .miFare(sTag) = tag {
                
                let tagUIDData = sTag.identifier
                var byteData: [UInt8] = []
                tagUIDData.withUnsafeBytes { byteData.append(contentsOf: $0) }
                var uidString = ""
                for byte in byteData {
                    let decimalNumber = String(byte, radix: 16)
                    if (Int(decimalNumber) ?? 0) < 16 { // add leading zero
                        uidString.append("0\(decimalNumber)")
                    } else {
                        uidString.append(decimalNumber)
                    }
                }
                
                self.completion?(.success(uidString))
                self.session?.alertMessage = "태그가 성공적으로 완료되었습니다."
                self.session?.invalidate()
                debugPrint("\(byteData) converted to Tag UID: \(uidString)")
                
            }else{
                self.session?.alertMessage = "태그 등록에 실패하였습니다.\n다시 시도해 주세요."
                self.session?.invalidate()
            }
        }
    }


    
}
