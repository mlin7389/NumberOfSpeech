//
//  TypingNumberView.swift
//  NumberOfSpeech
//
//  Created by user on 2022/3/9.
//

import SwiftUI

struct TypingNumberView: View {
    
    @EnvironmentObject var langModel : VoiceViewModel
    @Environment(\.colorScheme) var colorScheme
    
    
    let edgeInsets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    @State var isExpanded = true
    
    func titleFontColor() -> Color {
        
        if langModel.titlefontColorId == 0 {
            if colorScheme == .dark {
                return Color.white
            }
            else {
                return Color.black
            }
        }
        else {
            if colorScheme == .dark {
                return Color.red
            }
            else {
                return Color.red
            }
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text(langModel.typingText)
                    .font(.system(size: 80))
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.01)
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .frame(height: 80)
                    .border(Color.gray)
                    .foregroundColor(titleFontColor())
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 4, trailing: 10))
                
                HStack {
                    Button(action: {
                        langModel.showAnswer()
                    }, label: {
                        VStack {
                            Image(systemName: "eye")
                                .font(.system(size: 40))
                            Text("看答案")
                        }
                    })
                    .foregroundColor(Color.cusOrange)
                    Spacer()
                    if langModel.correctId == 1 {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(Color.green)
                            .font(.system(size: 40))
                            .minimumScaleFactor(0.01)
                            .scaledToFit()
                    }
                    else if langModel.correctId == 2 {
                        Image(systemName: "xmark.octagon")
                            .foregroundColor(Color.red)
                            .font(.system(size: 40))
                            .minimumScaleFactor(0.01)
                            .scaledToFit()
                    }
                    Spacer()
                    Button(action: {
                        langModel.readAgain()
                    }, label: {
                        VStack {
                            
                            Image(systemName: "mouth")
                                .font(.system(size: 40))
                            Text("重唸一次")
                        }
                        
                    }).foregroundColor(Color.cusOrange)
                }
                .padding(EdgeInsets(top: 4, leading:20, bottom: 0, trailing: 20))
                
                
                
                Spacer()
                
                ForEach(langModel.keys, id:\.self) { key in
                    HStack {
                        ForEach(key, id:\.self) { key2 in
                            Button(action: {
                                langModel.keyTap(key: key2)
                            }, label: {
                                Text(key2)
                                    .font(.system(size: 50))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                
                            })
                            .padding(edgeInsets)
                            .background(colorScheme == .dark ? Color.black : Color.cusLightGray)
                           
                        }
                    }
                }
                
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            .navigationBarTitle("聽力測驗", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: TypingNumberSettingView()) {
                        Text("設定")
                    }
                }
            }
        }
    }
}

struct TypingNumberView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TypingNumberView()
                .previewDevice("iPhone 11")
                .environmentObject(VoiceViewModel())
        }
    }
}
