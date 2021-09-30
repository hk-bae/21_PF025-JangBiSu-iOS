//
//  TTSUtility.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/09/30.
//

import Foundation
import AVFoundation

class TTSUtility : NSObject,AVSpeechSynthesizerDelegate{
    private static let shared = TTSUtility()
    
    var synthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    var utterance : AVSpeechUtterance!
    
    private override init(){
        super.init()
        synthesizer.delegate = self
    }
    
    static func speak(string: String){
        shared.speak(string)
    }
    
    private func speak(_ string: String){
        utterance = AVSpeechUtterance(string:string)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
        try? AVAudioSession.sharedInstance().setCategory(.playback,options: .duckOthers)
        
    }
}
