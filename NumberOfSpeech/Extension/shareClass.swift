//
//  shareClass.swift
//  NumberOfSpeech
//
//  Created by user on 2022/3/8.
//

import Foundation
import AVFoundation


extension Notification.Name {
    static let taskSpeckNotification = Notification.Name("TaskSpeckNotification")
}

struct Print {
    static func out(_ text:Any) {
#if DEBUG
       print(text)
#endif
    }
}

enum SettingType {
    case lowerValue
    case UpperValue
    case Count
}

struct ButtonStatus {
    static var Disable = true
    static var Enable = false
}

struct MaskStatus {
    static var NoMask = true
    static var Mask = false
}

struct SettingName {
    static let Settings = "Settings"
}

struct Cal {
    
    static func getRandomNumber(start:Int,end:Int) -> Int {
        
        var s1 = 0
        var s2 = 1
        if start == end {
            s1 = start
            s2 = end + 1
        }
        else if start > end {
            s1 = end
            s2 = start
        }
        else {
            s1 = start
            s2 = end
        }
        
        return Int.random(in: s1...s2)
    }
    
    static func t1(text:String,foucesTel:Bool) -> String{

        var sArr = Array(String(text))
        let digit_cnt = sArr.count
        
        if foucesTel == true {
            if digit_cnt == 9 {
                if (sArr[0] == "9") {
                    let a = text.substring(fromIndex: 0, getLength: 3)
                    let b = text.substring(fromIndex: 3, getLength: 3)
                    let c = text.substring(fromIndex: 6, getLength: 3)
                    return String(format: "0%@ %@ %@", a,b,c)
                }
                else {
                    let a = text.substring(fromIndex: 0, getLength: 1)
                    let b = text.substring(fromIndex: 1, getLength: 4)
                    let c = text.substring(fromIndex: 5, getLength: 4)
                    return String(format: "0%@ %@ %@", a,b,c)
                }
            }
            else if digit_cnt == 8 {
                let a = text.substring(fromIndex: 0, getLength: 1)
                let b = text.substring(fromIndex: 1, getLength: 3)
                let c = text.substring(fromIndex: 4, getLength: 4)
                return String(format: "0%@ %@ %@", a,b,c)
            }
        }
       
 
        for _ in 1...digit_cnt {  //最多產生的空白數

            let insert_index = sArr.count - 1            //要插入陣列的索引值最大值
            let index = Int.random(in: 0...insert_index)
            
            //Print.out("index:[\(index)]")

            if index == 0 {
                 if sArr[index] != "0"  {
                     let ts = Int.random(in: 0...100)
                     if ts > 50 {
                         sArr.insert("0", at: index)
                     }
                }
            }
            else if (index+1) > insert_index {    //要插入至尾巴的前一個位置，並確認再前一個字不可是空白
                if sArr[index] != " " && sArr[index-1] != " " {
                    sArr.insert(" ", at: index)
                    //Print.out("a:[\(String(sArr))]")
                }
            }
            else if sArr[index] != " " && sArr[index-1] != " " && sArr[index+1] != " " {
                sArr.insert(" ", at: index)
                //Print.out("a:[\(String(sArr))]")
            }
        }
        
        let number = String(sArr)
        return number
    }
}

// MARK: - EngNumber
struct EngNumber : Identifiable, Hashable {
    let id : String
    let number : String   // 要唸出來的號碼
    var isReading : Bool  // 正在被唸的號碼要出現喇叭圖示
    var isDone : Bool {
        didSet {
            if isDone == true {
                maskNumber = number
            }
            else {
                if disabledMask == MaskStatus.NoMask {
                    maskNumber = number
                }
            }
        }
    }
    
   var disabledMask : Bool {
        didSet {
            if disabledMask == MaskStatus.Mask && isDone == false {
                maskNumber = ""
                for _ in 1...String(number).count {
                    maskNumber = maskNumber + "*"
                }
            }
            else {
                maskNumber = number
            }
        }
    }
    
    var maskNumber : String = ""
    
    init(Number n:Int,disabledMask mask:Bool,numberTextMode:Bool,identifyTel:Bool) {
        id  = UUID().uuidString
        
        if identifyTel == true {
            number = Cal.t1(text: String(n),foucesTel: identifyTel)
        }
        else {
            if numberTextMode == true  {
                let tmp = Int.random(in: 1..<101)
                if tmp > 50 {
                    number = Cal.t1(text: String(n),foucesTel: identifyTel)
                }
                else{
                    number  =  n.formatted()
                }
            }
            else {
                number  = n.formatted()
            }
        }
        

        isReading = false
        isDone = false
        maskNumber = ""
        disabledMask = mask
        let cnt = String(n).count
        for _ in 1...cnt {
            maskNumber = maskNumber + "*"
        }
        
    }
    


}

// MARK: - VoiceLang
struct VoiceLang : Identifiable, Hashable, Encodable, Decodable{
    //VoiceLang(id: "38C722DB-D749-4CE2-901D-C03D954E890A", language: "英文", languageCode: "en-US", localizedCountryName: "美國")

    // MARK: 屬性
    var id : String
    var language : String     // 語言名稱
    var languageCode : String // 語言的代碼例 en_US
    var localizedCountryName : String //語言所屬的地區國家名稱
    
    var voiceLangString : String {
        get {
            return "\(self.language) \(self.localizedCountryName) \(self.languageCode)"
        }
    }
    
    // MARK: 建構子
    init(language lg:String,languageCode lgc:String,localizedCountryName c:String) {
        language = lg
        languageCode = lgc
        localizedCountryName = c
        id = UUID().uuidString
    }
    
    init(){
         id = UUID().uuidString
         language = "英文"
         languageCode = "en-US"
         localizedCountryName = "美國"
    }
}

// MARK: - Setting
struct Setting : Encodable, Decodable {
    
    // MARK: 屬性
    var disabelMaskNumber : Bool = MaskStatus.Mask
    var isExpendSetting : Bool = true
    
    var identifyTel : Bool = false {
        didSet {
            if (identifyTel == true && self.numberTextMode == false)  {
                self.numberTextMode = true
            }
        }
    }
    
    var lowerNumber: Int = 10
    var upperNumber: Int = 100
    var keyboardSound : Bool = true
    
    var numberTextMode : Bool = false {
        didSet {
            if numberTextMode == false {
                identifyTel = false
            }
        }
    }
    var _count : Int = 20
    var count : Int
    {
        get {
            if _count == 0 {
                return _count + 1
            }
            return _count
        }
        set {
            if newValue > 999 {
                _count = 999
            }
            else {
                _count = newValue
            }
        }
    }
    
    
    var speedOfSpeak : Float = 0.5
    var gapOfSpeak : Float = 0.0
    var autoPlayNextNumber : Bool = true
    var voiceLang : VoiceLang = VoiceLang()
    var autoPlayDelay : Float = 0.5
    var autoPlayDelayString : String {
        get {
            return String(format: "%.1f", autoPlayDelay)
        }
    }
    
    // MARK: 建構子
    init() {
        if let items1 = UserDefaults.standard.data(forKey:  SettingName.Settings) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Setting.self, from: items1)     {
                self = decoded
                if self.upperNumber <= 0 {
                    self.upperNumber = 100
                }
                if self.count <= 10 {
                    self.count = 10
                }
                if self.lowerNumber <= 0 {
                    self.lowerNumber = 0
                }
            }
        }
       
    }
}

// MARK: - Loading
struct Loading {
    static func Languages() -> ([VoiceLang]) {
        var voiceLangs_tmp = [VoiceLang]()
        var languageCodes : [String] = []
        let speechVoices = AVSpeechSynthesisVoice.speechVoices()
        for row in 0...speechVoices.count-1 {
            let language = Locale(identifier: "zh-TW").localizedString(forLanguageCode: speechVoices[row].language)!
            
        
            //let aiName = Locale.current.localizedString(forIdentifier: speechVoices[row].identifier)!
            let languageCode = speechVoices[row].language
            
            if languageCodes.contains(languageCode) == false {
                languageCodes.append(languageCode)
                let codes = languageCode.components(separatedBy:"-")
                let localizedCountryName = Locale(identifier: "zh-TW").localizedString(forRegionCode: String(codes[1]))
                
                let v = VoiceLang(language: language, languageCode: languageCode,localizedCountryName: (localizedCountryName ?? ""))
                //Print.out(v.language)
                voiceLangs_tmp.append(v)
                
            }
        }
        return voiceLangs_tmp
    }
}

