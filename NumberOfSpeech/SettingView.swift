//
//  SettingView.swift
//  NumberOfSpeech
//
//  Created by user on 2022/3/6.
//

import SwiftUI
import Combine


struct SettingView: View {

  
    @FocusState private var focused
    @State var isMark = false
    @EnvironmentObject var langModel : VoiceViewModel
    @State var presentingModal1 = false
    @State var presentingModal2 = false
    @State var presentingModal3 = false
    let edgeInsets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
 
    let formatter3: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .decimal
          formatter.maximumIntegerDigits = 3
          return formatter
      }()
    
    let formatterLower: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .none
          formatter.maximumIntegerDigits = 13
          return formatter
      }()
    
    let formatterUp: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .none
          formatter.maximumIntegerDigits = 13
          return formatter
      }()
    
    init() {
        UITextField.appearance().clearButtonMode = .whileEditing

    }
    
    
    var body: some View {
        
        VStack {
            DisclosureGroup(isExpanded: $langModel.settingValue.isExpendSetting, content: {
                
                VStack(alignment: .leading)  {
                    VStack {
                        HStack {
                            Button(action: {
                                langModel.settingValue.speedOfSpeak = 0.5
                            }, label: {
                                Text("語音速度")
                                    .frame(width: 80,alignment: .trailing)
                            })
                            
                            Slider(value: $langModel.settingValue.speedOfSpeak, in: 0...1)
                        }
                        HStack {
                            Button(action: {
                                langModel.settingValue.gapOfSpeak = 0.0
                            }, label: {
                                Text("語音間隔")
                                    .frame(width: 80,alignment: .trailing)
                            })
                            
                            Slider(value: $langModel.settingValue.gapOfSpeak, in: 0...3)
                        }
                    }
                    HStack {
                        Text("最  小  值")
                            .frame(width: 80, alignment: .trailing)
                        Button(action: {
                            presentingModal1.toggle()
                        }, label: {
                            HStack() {
                                Text("\(langModel.settingValue.lowerNumber)")
                                    .font(.system(size: 20))
                                Spacer()
                            }
                        })
                        .padding(edgeInsets)
                        .frame(maxWidth:.infinity)
                        .border(Color.gray)
                        .sheet(isPresented: $presentingModal1) {
                            NumberKeyboardView(titleMsg: "設定最小值",settingOfType: .lowerValue,textOfNumber:String(" "),limitLen:13)
                        }
                    }
                    HStack {
                        Text("最  大  值")
                            .frame(width: 80, alignment: .trailing)
                        Button(action: {
                            presentingModal2.toggle()
                        }, label: {
                            HStack() {
                                Text("\(langModel.settingValue.upperNumber)")
                                    .font(.system(size: 20))
                                Spacer()
                            }
                        })
                        .padding(edgeInsets)
                        .frame(maxWidth:.infinity)
                        .border(Color.gray)
                        .sheet(isPresented: $presentingModal2) {
                            NumberKeyboardView(titleMsg: "設定最大值",settingOfType: .UpperValue,textOfNumber:String(" "),limitLen:13)
                        }
                    }
                    HStack {
                        Text("產生筆數")
                            .frame(width: 80, alignment: .trailing)
                        Button(action: {
                            presentingModal3.toggle()
                        }, label: {
                            HStack() {
                                Text("\(langModel.settingValue.count)")
                                    .font(.system(size: 20))
                                Spacer()
                            }
                        })
                        .padding(edgeInsets)
                        .frame(maxWidth:.infinity)
                        .border(Color.gray)
                        .sheet(isPresented: $presentingModal3) {
                            NumberKeyboardView(titleMsg: "設定每次產生筆數",settingOfType: .Count,textOfNumber:String(" "),limitLen:3)
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
                
                if self.focused == true {
                    Button(action: {
                        focused = false
                    }, label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .font(.system(size: 30))
                    })
                }
                
                VStack (alignment: .leading ){
                    Toggle(isOn: $langModel.settingValue.numberTextMode) {
                        VStack (alignment: .leading ){
                            Text("數字隨機拆分模式")
                                .minimumScaleFactor(0.1)
                                .scaledToFit()
                        }
                    }
                    HStack {
                        Button(action: {
                            langModel.playNumber(text: "799")
                        }, label: {
                            Image(systemName: "mic")
                            Text("純數字 799")
                        })
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:30))
                        //.border(Color.blue)
                        
                        Button(action: {
                            langModel.playNumber(text: "7 99")
                        }, label: {
                            Image(systemName: "mic")
                            Text("數字拆分 799")
                        })
                        //.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                        // .border(Color.blue)
                    }
                    Toggle(isOn: $langModel.settingValue.identifyTel) {
                        VStack (alignment: .leading ){
                            Text("識別台灣電話號碼")
                                .minimumScaleFactor(0.1)
                                .scaledToFit()
                            Text("8~9碼數字自動轉手機或市話格式")
                                .font(.system(size: 14))
                                .foregroundColor(Color.cusGray)
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
                
            }, label: {
                if langModel.settingValue.isExpendSetting == true {
                    Text("詳細設定(點擊收合)")
                        .foregroundColor(Color.cusOrange)
                        .font(.system(size: 20))
                }
                else {
                    Text("詳細設定(點擊展開)")
                        .foregroundColor(Color.cusOrange)
                        .font(.system(size: 20))
                }
                
            })
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            
            List {
                Section(header:
                            Button(action: {
                    langModel.playNumber(text: "0 1 2 3 4 5 6 7 8 9")
                }, label: {
                    HStack {
                        Image(systemName: "mic")
                        Text(String(format: "%@", langModel.settingValue.voiceLang.voiceLangString))
                    }
                })
                  .font(.system(size: 20))
                  .foregroundColor(Color.cusOrange)
                )
                {
                    ForEach(langModel.voiceLangs) { lang in
                        Button(action: {
                            langModel.settingValue.voiceLang = lang
                        }, label: {
                            HStack {
                                Text("\(lang.languageCode)")
                                Text("\(lang.localizedCountryName)")
                                Spacer()
                                Text("\(lang.language)")
                            }
                        })
                    }
                }
            }
            .listStyle(.plain)
            Spacer()
        }

    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(VoiceViewModel())
    }
}
