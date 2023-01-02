//
//  VoiceString.swift
//  語言數字聽力
//
//  Created by user on 2022/3/13.
//

import SwiftUI

struct VoiceStringView: View {
    
    @State var text = "0925-789-732"
    @EnvironmentObject var langModel : VoiceViewModel
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var focused
    
    var body: some View {
        VStack {
            TextField("輸入文字", text: $text)
                .focused($focused)
                .padding()
                .border(Color.gray)
            Button(action: {
                langModel.playWithString(text: text)
            }, label: {
                Text("Play")
            })
            
            if self.focused == true {
                Button(action: {
                    focused = false
                }, label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                        .font(.system(size: 30))
                })
            }
            Spacer()
        }
        
    }
}

struct VoiceStringView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceStringView()
    }
}
