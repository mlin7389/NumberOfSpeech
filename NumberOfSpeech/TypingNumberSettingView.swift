//
//  TypingNumberSettingView.swift
//  NumberOfSpeech
//
//  Created by user on 2022/3/9.
//

import SwiftUI

struct TypingNumberSettingView: View {
    
    @EnvironmentObject var langModel : VoiceViewModel
    
    var body: some View {
        VStack {
            HStack {
                Toggle(isOn: $langModel.settingValue.autoPlayNextNumber) {
                    Text("答對後自動播放")
                        .font(.system(size: 20))
                        .minimumScaleFactor(0.1)
                        .scaledToFit()
                }
            }
            .padding()
            HStack {
                Stepper(label: {
                    Button(action: {
                        langModel.settingValue.autoPlayDelay = 0.5
                    }, label: {
                        Text(String(format:"自動播放延遲%@秒", langModel.settingValue.autoPlayDelayString))
                    })
                    .font(.system(size: 20))
                    .minimumScaleFactor(0.1)
                    .scaledToFit()
                    
                }, onIncrement: {
                    langModel.settingValue.autoPlayDelay += 0.1
                 
                }, onDecrement: {
                    langModel.settingValue.autoPlayDelay -= 0.1
                    if langModel.settingValue.autoPlayDelay < 0.1 {
                        langModel.settingValue.autoPlayDelay = 0.1
                    }
                })
            }
            .padding()
            HStack {
                Text("鍵盤音")
                    .font(.system(size: 20))
                Spacer()
                Button(action: {
                    langModel.settingValue.keyboardSound.toggle()
                }, label: {
                    HStack {
                        if langModel.settingValue.keyboardSound == false  {
                            Image(systemName: "speaker.slash")
                                .font(.system(size: 30))
                        }
                        else {
                            Image(systemName: "speaker.wave.2")
                                .font(.system(size: 30))
                        }
                       
                    }
                    .foregroundColor(langModel.settingValue.keyboardSound == true ? Color.blue : Color.gray)
                })
            }
            .padding()
            Spacer()
        }
        .padding()
        .navigationTitle("測驗設定")
    }
}

struct TypingNumberSettingView_Previews: PreviewProvider {
    static var previews: some View {
        TypingNumberSettingView()
            .environmentObject(VoiceViewModel())
    }
}
