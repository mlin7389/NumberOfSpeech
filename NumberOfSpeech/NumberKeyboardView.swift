//
//  NumberKeyboardView.swift
//  語言數字聽力
//
//  Created by user on 2022/3/13.
//

import SwiftUI
import AVFoundation
struct NumberKeyboardView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var langModel : VoiceViewModel
    @Environment(\.colorScheme) var colorScheme
    let edgeInsets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
  
    @State var titleMsg : String
    @State var settingOfType : SettingType
    @State var textOfNumber : String
    @State var limitLen : Int
    var body: some View {
        NavigationView {
            VStack {
                Text("該設定數字限制最長為 \(limitLen) 碼")
                    .foregroundColor(Color.cusDrakRed)
                    .font(.system(size: 24))
                HStack {
                    Text("\(textOfNumber)")
                        .padding()
                        .frame(maxWidth:.infinity)
                        .background(colorScheme == .dark ? Color.cusDarkYellow : Color.cusLightYellow)
                        .border(Color.cusGray)
                        .font(.system(size: 36))
                 
                }
                ForEach(langModel.keys2, id:\.self) { rowKey in
                    HStack {
                        ForEach(rowKey, id:\.self) { key in
                            Button(action: {
                                AudioServicesPlaySystemSound(SystemSoundID(1104))  //鍵盤音效
                                if key == "⏎" {
                                    if langModel.setValueOfTextNumer(settingOfType: settingOfType, value: textOfNumber) == true {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                   
                                }
                                else if key == "C" {
                                    textOfNumber = " "
                                }
                                else {
                                    if textOfNumber.count < limitLen {
                                        if textOfNumber == " " {
                                            textOfNumber = "\(key)"
                                        }
                                        else {
                                            textOfNumber = "\(textOfNumber)\(key)"
                                        }
                                    }
                                    else {
                                        
                                    }
                                }
                            }, label: {
                                Text(key)
                                    .font(.system(size: 50))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                
                            })
                            .padding(edgeInsets)
                            .background(colorScheme == .dark ? Color.black : Color.cusLightGray)
                           
                        }
                    }
                }
               
            }
            .navigationBarTitle("\(self.titleMsg)")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("取消")
                    })
                }
            }
        }
       
        
    }
}

struct NumberKeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        NumberKeyboardView(titleMsg: "設定數值",settingOfType: .Count,textOfNumber:"123",limitLen:13)
            .environmentObject(VoiceViewModel())
    }
}
