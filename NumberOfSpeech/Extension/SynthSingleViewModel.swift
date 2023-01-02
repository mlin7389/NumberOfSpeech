//
//  SynthSingleViewModel.swift
//  語言數字聽力
//
//  Created by user on 2022/3/13.
//

import Foundation
import AVFoundation

class SynthSingleViewModel: NSObject, ObservableObject {
    
    private var speechSynthesizer = AVSpeechSynthesizer()
    var playSingle = false     // 單一數字播放時設定為true，等到唸完後才改為false，避免重覆執行
    var languageCode : String
    var speedOfSpeak : Float
    var delayTime : Float
    
    override init() {
        languageCode = "en-US"
        speedOfSpeak = 0.5
        delayTime = 0
        super.init()
        self.speechSynthesizer.delegate = self
    }
    
    func speakSingleNumber(text: String,languageCode lngc:String,speedOfSpeak sp:Float) {
        languageCode = lngc
        speedOfSpeak = sp
        playSingle = true
        delayTime = 0
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        utterance.rate = speedOfSpeak
        speechSynthesizer.speak(utterance)
    }
    
}

// MARK: - Delegate

extension SynthSingleViewModel: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Print.out("didStart")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        Print.out("didPause")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        Print.out("didContinue")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Print.out("didCancel")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        Print.out("characterRange")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Print.out("didFinish")
        if playSingle == true {
            playSingle = false
        }
    }
}
