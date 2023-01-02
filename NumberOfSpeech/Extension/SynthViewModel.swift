//
//  Speaker.swift
//  NumberOfSpeech
//
//  Created by user on 2022/3/6.
//

import Foundation
import AVFoundation
import SwiftUI

class SynthViewModel: NSObject, ObservableObject {

    override init() {
        currentIndex = 0
        engNumbers = []
        languageCode = "en-US"
        focuseStop = false
        keepPlaying = false
        focusePause = false
        speedOfSpeak = 0.5
        delayTime = 0
        super.init()
        self.speechSynthesizer.delegate = self
    }
    
    // MARK: - 屬性
    
    private var speechSynthesizer = AVSpeechSynthesizer()
    var currentIndex : Int                // 目前正在被唸到的陣列索引
    var engNumbers : [EngNumber]
    var languageCode : String
    var speedOfSpeak : Float
    var onCompleteRead_A_Number: ((Int) -> Void)?     //唸完一個數字
    var onStartPlaying_A_Number: ((Bool) -> Void)?    //開始唸一個數字
    var onFinishedOfReadingAllNumbers: (() -> Void)?  //完成唸完所有數字
   
  
    var delayTime : Float
    var focusePause : Bool  // 當該變數為true時會中止清單播放，正在播放的單字結束後才會中止
    var focuseStop : Bool   // 當該變數為true時會停止清單播放，正在播放的單字結束後才會停止
    var keepPlaying : Bool  // 開始播放時為true 被按下中止或停止時才為false，用於禁止自動播放過程的手點擊播放功能
    
    
    // MARK: - 方法
  
    func speakNumber(texts: [EngNumber],languageCode lngc:String,speedOfSpeak sp:Float,delay:Float) {
        engNumbers = texts
        languageCode = lngc
        speedOfSpeak = sp
        delayTime = delay
        
        speakNumber_internal()
    }
    
    func speakNumber_internal()  {
        
        if self.focuseStop == true {
            return
        }
        
        if self.focusePause == true {
            return
        }
        
        if let CallBackFunc = self.onCompleteRead_A_Number {
            CallBackFunc(currentIndex)
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.delayTime)) {
            self.speakNumber_internal2()
        }
 
    }
    
    func speakNumber_internal2() {
        NotificationCenter.default.post(name: Notification.Name.taskSpeckNotification , object: currentIndex)
        let text = String(engNumbers[currentIndex].number)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        utterance.rate = speedOfSpeak
        
        self.speechSynthesizer.speak(utterance)

    }
    
  
    
}

// MARK: - Delegate

extension SynthViewModel: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Print.out("didStart")
        if let CallBackFunc = self.onStartPlaying_A_Number {
            CallBackFunc(true)
        }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        Print.out("didPause")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        Print.out("didContinue")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Print.out("didCancel")
        self.focusePause = true
        if let CallBackFunc = self.onStartPlaying_A_Number {
            CallBackFunc(false)
        }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        Print.out("characterRange")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Print.out("didFinish")
        
        if  keepPlaying == false {
            return
        }
  
        currentIndex += 1
        
        if currentIndex <= (engNumbers.count-1) {
            self.speakNumber_internal()
        }
        else {
            keepPlaying = false
            currentIndex = 0

            if let CallBackFunc = self.onFinishedOfReadingAllNumbers {
                CallBackFunc()
            }
        }
     
        if let CallBackFunc = self.onStartPlaying_A_Number {
            CallBackFunc(false)
        }
    }
}
