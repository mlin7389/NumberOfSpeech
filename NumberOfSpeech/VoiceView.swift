//
//  ContentView.swift
//  NumberOfSpeech
//
//  Created by user on 2022/3/6.
//

import SwiftUI



struct VoiceView: View {
    
    @EnvironmentObject var langModel : VoiceViewModel
    let edgeInsets = EdgeInsets(top: 6, leading: 20, bottom: 0, trailing: 20)
    @Environment(\.colorScheme) var colorScheme
  
    var body: some View {
    
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        langModel.stopPlayNumer()
                    }, label: { Image(systemName: "stop.fill") })
                    .padding(edgeInsets)
                    .disabled(langModel.stopStatus)
                    
                    Button(action: {
                        langModel.pasuePlayNumer()
                    }, label: { Image(systemName: "pause.fill") })
                    .padding(edgeInsets)
                    .disabled(langModel.pasueStatus)
                    
                    Button(action: {
                        langModel.playListOfNumber()
                    }, label: { Image(systemName: "play.fill") })
                    .padding(edgeInsets)
                    .disabled(langModel.playStatus)
                    
                    Spacer()
                    
                    Button(action: {
                        langModel.createNumers()
                    }, label: { Image(systemName: "arrow.clockwise") })
                    .padding(edgeInsets)
                    .disabled(refreshButtonDisabled())
                    Spacer()
                }
                .font(.system(size: 30))
                .padding()
                Spacer()
                
                HStack {
                    Text(langModel.settingValue.voiceLang.voiceLangString)
                     .frame(width: 200, alignment: .leading)
                    .font(.system(size: 20))
                    .foregroundColor(Color.cusDrakRed)
                    
                    Toggle("", isOn: $langModel.settingValue.disabelMaskNumber)
                        .tint(.orange)
                        .onChange(of: langModel.settingValue.disabelMaskNumber, perform: { newValue in
                            
                        })
                }
                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                .background(colorScheme == .dark ? Color.cusDarkGray : Color.cusLightGray)
                
                ScrollViewReader { scrollView in
                    ScrollView(.vertical) {
                        LazyVStack {
                            ForEach(langModel.engNumbers, id:\.self) { item in
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        langModel.playNumber(text:String(item.number))
                                    }, label: {
                                        Text("\(item.maskNumber)")
                                            .font(.system(size: 22))
                                            .foregroundColor(item.isDone == true ? Color.green : Color.blue)
                                    })
                                    .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 0))
                                   
                                    if item.isReading == true {
                                        Image(systemName: "speaker.wave.2")
                                            .font(.system(size: 22))
                                            .foregroundColor(Color.blue)
                                    }
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 0))
                                .border(Color.cusLightGray)
                                .background(readingBackground(isReading:item.isReading))
                            }
                            
                        }
                        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.taskSpeckNotification), perform: { value in
                            Print.out(value.object!)
                            let index = (value.object as? Int ?? 0)!
                            withAnimation {
                                scrollView.scrollTo(langModel.engNumbers[index])
                            }
                            
                        })
                    }
                     
                }
                
//                List {
//                    Section(header: HStack {
//                        Label(title: {
//                            Text(langModel.settingValue.voiceLang.voiceLangString)
//                                .frame(width: 200)
//                        }, icon: {
//                            Image(systemName: "mic")
//                        })
//                        .font(.system(size: 20))
//                        .foregroundColor(Color.cusDrakRed)
//
//                        Toggle("", isOn: $langModel.settingValue.disabelMaskNumber)
//                            .tint(.orange)
//                            .onChange(of: langModel.settingValue.disabelMaskNumber, perform: { newValue in
//                            })
//                    }) // End of Section
//                    {
//                        ForEach(langModel.engNumbers, id:\.self) { item in
//                            HStack {
//                                Button(action: {
//                                    langModel.playNumber(number: item.number)
//                                }, label: {
//                                    Text("\(item.maskNumber)")
//                                        .font(.system(size: 24))
//                                })
//                                .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 0))
//
//                                if item.isReading == true {
//                                    Image(systemName: "speaker.wave.2")
//                                        .font(.system(size: 24))
//                                        .foregroundColor(Color.blue)
//                                }
//                            }
//                        }
//                    }
//                }
//                .listStyle(.plain)
            }
            .padding()
            .navigationBarTitle("數字播放清單", displayMode: .inline)
        }
        
    }
    
    func refreshButtonDisabled() -> Bool {
        return langModel.refreshButtonDisabled()
    }
    
    func readingBackground(isReading:Bool) -> Color {
        if isReading == true {
            if colorScheme == .dark {
                return Color.cusDarkYellow
            }
            else {
                return Color.cusLightYellow
            }
           
        }
        else {
            if colorScheme == .dark {
                return Color.black
            }
            else {
                return Color.white
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceView()
            .environmentObject(VoiceViewModel())
    }
}
