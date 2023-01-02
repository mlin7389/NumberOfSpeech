//
//  ViewModel.swift
//  NumberOfSpeech
//
//  Created by user on 2022/3/6.
//

import Foundation
import AVFoundation
import SwiftUI

class VoiceViewModel : ObservableObject {

    // MARK: - 屬性
    var voiceLangs : [VoiceLang]
    var synthVM : SynthViewModel
    var synthSingleVM : SynthSingleViewModel
    
    @Published var playStatus = ButtonStatus.Enable
    @Published var pasueStatus = ButtonStatus.Disable
    @Published var stopStatus = ButtonStatus.Disable
    @Published var typingText : String = ""
    @Published var titlefontColorId = 0
    @Published var engNumbers : [EngNumber]
    @Published var settingValue : Setting {
        didSet {
            synthVM.languageCode = settingValue.voiceLang.languageCode
            synthVM.speedOfSpeak = settingValue.speedOfSpeak
            saveSettingFromName(source: settingValue,
                                forKey: SettingName.Settings)
            
            if engNumbers.count > 0 {
                for i in 0...engNumbers.count - 1 {
                    self.engNumbers[i].disabledMask = settingValue.disabelMaskNumber
                }
            }
        
        }
    }
    @Published var finishedFlg : Bool
    {
        didSet {
            playStatus = ButtonStatus.Enable
            pasueStatus = ButtonStatus.Disable
            stopStatus = ButtonStatus.Disable
        }
    }
    
    //MARK: - 建構子
    
    init() {
        Thread.sleep(forTimeInterval: 1.0)
        finishedFlg = false
        voiceLangs = Loading.Languages()
        settingValue = Setting()
        synthVM = SynthViewModel()
        synthSingleVM = SynthSingleViewModel()
        engNumbers = []
        createNumers()
        
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            Print.out("audioSession properties weren't set because of an error.")
        }
    }

    //MARK: - 方法

    func createNumers(){
        
        if settingValue.lowerNumber > settingValue.upperNumber {
            let t = settingValue.upperNumber
            settingValue.upperNumber = settingValue.lowerNumber
            settingValue.lowerNumber = t
        }
        
        engNumbers.removeAll()
        for _ in 0..<settingValue.count {
            let randomNumber = Cal.getRandomNumber(start: settingValue.lowerNumber, end: settingValue.upperNumber)
            let item = EngNumber(Number: randomNumber,disabledMask: settingValue.disabelMaskNumber,numberTextMode: settingValue.numberTextMode,identifyTel: settingValue.identifyTel)
            engNumbers.append(item)
        }
        
        initReading()
    }

    func loadSettingFromName<T:Decodable>(keyName:String, dest: inout T) {
        if let items1 = UserDefaults.standard.data(forKey: keyName) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: items1)     {
                dest = decoded
            }
        }
    }

    func saveSettingFromName<T:Encodable>(source: T,forKey key:String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(source) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

   

    func stopPlayNumer() {
        playStatus = ButtonStatus.Disable
        pasueStatus = ButtonStatus.Disable
        stopStatus = ButtonStatus.Disable
        synthVM.focuseStop = true
    }
    
    func pasuePlayNumer() {
        playStatus = ButtonStatus.Disable
        pasueStatus = ButtonStatus.Disable
        stopStatus = ButtonStatus.Disable
        synthVM.focusePause = true
    }

    func playListOfNumber() {
       
        playStatus = ButtonStatus.Disable
        pasueStatus = ButtonStatus.Enable
        stopStatus = ButtonStatus.Enable
        
        if synthVM.onStartPlaying_A_Number == nil {
            synthVM.onStartPlaying_A_Number = onStartPlaying_A_Number
        }
        
        if synthVM.onCompleteRead_A_Number == nil {
            synthVM.onCompleteRead_A_Number = onCompleteRead_A_Number
        }
        
        if synthVM.onFinishedOfReadingAllNumbers == nil {
            synthVM.onFinishedOfReadingAllNumbers = onFinishedOfReadingAllNumbers
        }
        
        if synthVM.focusePause == true {  //從暫停後再播放，取消狀態
            synthVM.focusePause = false
        }

        self.engNumbers[synthVM.currentIndex].isReading = true
        self.synthVM.keepPlaying = true
        synthVM.speakNumber(texts: self.engNumbers,languageCode: settingValue.voiceLang.languageCode,speedOfSpeak: settingValue.speedOfSpeak,delay: settingValue.gapOfSpeak)
    }
    
    func refreshButtonDisabled() -> Bool {
        if self.playStatus == ButtonStatus.Enable &&
            self.pasueStatus == ButtonStatus.Disable &&
            self.stopStatus == ButtonStatus.Disable{
            return false
        }
        return true
    }
    
    func onStartPlaying_A_Number(playing:Bool) {
        
        if playing == false {
            if synthVM.focuseStop == true {
                onFinishedOfReadingAllNumbers()
            }
            
            if synthVM.focusePause == true {
                playStatus = ButtonStatus.Enable
                pasueStatus = ButtonStatus.Disable
                stopStatus = ButtonStatus.Disable
            }
            
        }
    }
    
    func initReading() {

        singlePlaying = false
        synthVM.focuseStop = false
        synthVM.keepPlaying = false
        playStatus = ButtonStatus.Enable
        pasueStatus = ButtonStatus.Disable
        stopStatus = ButtonStatus.Disable
        
        for i in 0...engNumbers.count - 1 {
            engNumbers[i].isReading = false
            engNumbers[i].isDone = false
        }
        synthVM.currentIndex = 0
    }
    
    func onFinishedOfReadingAllNumbers() {

        singlePlaying = false
        synthVM.focuseStop = false
        synthVM.keepPlaying = false
        playStatus = ButtonStatus.Enable
        pasueStatus = ButtonStatus.Disable
        stopStatus = ButtonStatus.Disable

        for i in 0...engNumbers.count - 1 {
            engNumbers[i].isReading = false
            engNumbers[i].isDone = true
        }
        
        synthVM.currentIndex = 0
    }
    
    func onCompleteRead_A_Number(currIndex:Int) {
        if currIndex >= 1 {
            self.engNumbers[currIndex-1].isReading = false
            self.engNumbers[currIndex-1].isDone = true
            self.engNumbers[currIndex].isReading = true
        }
    }
    
    func maskNumberFunc() {
        //langModel.settingValue.disabelMaskNumber
        
        if self.settingValue.disabelMaskNumber == MaskStatus.Mask {
            for i  in 0...engNumbers.count - 1 {
                if self.engNumbers[i].isDone == false {
                    self.engNumbers[i].disabledMask = MaskStatus.Mask
                }
            }
            
        }
        else {
            for i in 0...engNumbers.count - 1 {
                self.engNumbers[i].disabledMask = MaskStatus.NoMask
            }
        }
        
        
    }
    
    
    // MARK: - TypingNumberView使用
    
    let keys = [["1","2","3"],["4","5","6"],["7","8","9"],["C","0","▶"]]
    var correctId = 0            //用於梆定畫面要顯示的圖示
    var singlePlaying = false    //控管避免還沒唸完時重覆執行
    
    var keysCount : Int {
        get {
            self.keys.count
        }
    }
        
    func keyTap(key:String) {

        if self.settingValue.keyboardSound == true {
            if key != "▶" {
                AudioServicesPlaySystemSound(SystemSoundID(1104))  //鍵盤音效
            }
        }
       
        if titlefontColorId == 1 {
            titlefontColorId = 0
            correctId = 0
            typingText = ""
        }
        
        if key == "▶" {
            correctId = 0
            typingText = ""
            readNext()
        }
        else if key == "C" {
            correctId = 0
            typingText = ""
        }
        else {
  
            
            
            if typingText.count < String(numberOfText).count {
                typingText = String(format: "%@%@", typingText,key)
                
                if typingText == String(numberOfText) {
                    correctId = 1 //長度相同，正確

                    if self.settingValue.autoPlayNextNumber {
                        let d = Double(self.settingValue.autoPlayDelay)
                        DispatchQueue.main.asyncAfter(deadline: .now() + d) {
                            self.readNext()
                        }
                    }
                  
                }
                else {
                    if typingText.count == String(numberOfText).count {
                        correctId = 2 //長度相同，字串不同，錯誤
          
                        if self.settingValue.autoPlayNextNumber {
                            let d = Double(self.settingValue.autoPlayDelay)
                            DispatchQueue.main.asyncAfter(deadline: .now() + d) {
                                self.clearErrorNumber()
                            }
                        }
                      
                    }
                    else {
                        correctId = 0
                    }
                }
               
            }
            else {
                correctId = 2 //長度相同，字串不同，錯誤
            }
            
           
        }
      
    }
    
    func clearErrorNumber() {
        correctId = 0
        typingText = ""
    }
    
    func showAnswer() {
       titlefontColorId = 1
       typingText = String(numberOfText)
    }
    
    var numberOfText : String = "0"
    var numberOfText_forReading : String = "0"
    
    func readAgain() {
        playNumber(text: String(numberOfText_forReading))
    }
    
    func readNext() {
        correctId = 0
        typingText = ""
        
        if settingValue.lowerNumber > settingValue.upperNumber {
            let t = settingValue.upperNumber
            settingValue.upperNumber = settingValue.lowerNumber
            settingValue.lowerNumber = t
        }
 
        let number = Cal.getRandomNumber(start: settingValue.lowerNumber, end: settingValue.upperNumber)
        numberOfText = String(number)
        
        numberOfText_forReading = numberOfText

        if settingValue.identifyTel == true {
            numberOfText_forReading = Cal.t1(text: numberOfText,foucesTel: settingValue.identifyTel)
        }
        else {
            if settingValue.numberTextMode == true  {
                let tmp = Int.random(in: 1..<101)
                if tmp > 50 {
                    numberOfText_forReading = Cal.t1(text: numberOfText,foucesTel: settingValue.identifyTel)
                }
            }
        }
  
        //fix bug 去空白，隨機拆分數字清單會有0開頭，單一測驗比對要去掉空白
        numberOfText = numberOfText_forReading.replacingOccurrences(of: " ", with: "")
        
        playNumber(text: numberOfText_forReading)
        
        Print.out("numberOfText:\(numberOfText)")
        Print.out("numberOfText_forReading:\(numberOfText_forReading)")
    }
    
    func playNumber(text:String) {
        synthSingleVM.speakSingleNumber(text: text,languageCode: settingValue.voiceLang.languageCode,speedOfSpeak: settingValue.speedOfSpeak)
    }
    
    
    // MARK: - KEYBOARD
    let keys2 = [["1","2","3"],["4","5","6"],["7","8","9"],["C","0","⏎"]]
    
    func setValueOfTextNumer(settingOfType type:SettingType,value number:String) -> Bool {
        
        if let v = Int(number) {
            switch (type) {
            case .lowerValue:
                settingValue.lowerNumber = v
            case .UpperValue:
                if  v == 0 {
                    settingValue.upperNumber = 1
                }
                else {
                    settingValue.upperNumber = v
                }
            case .Count:
                if  v == 0 {
                    settingValue.count = 1
                }
                else {
                    settingValue.count = v
                }
            }
            return true
        }
        else {
            return false
        }
        
       
    }

}

