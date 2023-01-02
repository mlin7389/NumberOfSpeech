//
//  MainView.swift
//  NumberOfSpeech
//
//  Created by user on 2022/3/6.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var LangModel = VoiceViewModel()
    
    var body: some View {
        TabView {
            VoiceView().tabItem {
                NavigationLink(destination: VoiceView()) {
                    Image(systemName: "ear")
                    Text("清單測驗")
                }.tag(1)
            }

            TypingNumberView().tabItem {
                NavigationLink(destination: TypingNumberView()) {
                    Image(systemName: "pencil.and.outline")
                    Text("單一測驗")
                }.tag(2)
            }
            
            SettingView().tabItem {
                NavigationLink(destination: SettingView())
                {
                    Image(systemName: "gear")
                    Text("設定")
                }
                .tag(3)
            }
        }
        .environmentObject(LangModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
