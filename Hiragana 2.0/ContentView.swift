//
//  ContentView.swift
//  Hiragana 2.0
//
//  Created by dkab on 8/7/20.
//  Copyright © 2020 dkab. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let hiraganaSequence = ["a","i","u","e","o","ka","ki","ku","ke","ko","sa","shi","su","se","so","ta","chi","tsu","te","to","na","hi","fu","he","ho","ma","mi","mu","me","mo","ya","yu","yo","ra","ri","ru","re","ro","wa","wo","n"]
    let hiraganaSequenceToRead = ["あ","い","う","え","お","か","き","く","け","こ","さ","し","す","せ","そ","た","ち","つ","て","と","な","ひ","ふ","へ","ほ","ま","み","む","め","も","や","ゆ","よ","ら","り","る","れ","ろ","わ","を","ん"]
    
    @State var inOrder :Bool = true;
    @State var challange :Bool = false;
    @State var spelling :Bool = false;
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {print("play audio")}){
                    if colorScheme == .light {
                        GIFView(gifName: hiraganaSequence[0])
                            .frame(width: 300, height: 300, alignment: .center)
                    } else {
                        GIFView(gifName: hiraganaSequence[0])
                            .frame(width: 300, height: 300, alignment: .center)
                            .colorInvert()
                    }
                }
                VStack {
                    Toggle(isOn: $inOrder) {
                        Text("In order")
                    }
                    .toggleStyle(CheckMarkToggleStyle(label: "In order", color: .green))
                    
                    Toggle(isOn: $challange) {
                        Text("Challange")
                    }
                    .toggleStyle(CheckMarkToggleStyle(label: "Challange", color: .green))
                    
                    Toggle(isOn: $spelling) {
                        Text("Spelling")
                    }
                    .toggleStyle(CheckMarkToggleStyle(label: "Spelling", color: .green))
                }
                .padding(.vertical)
                .background(Color.gray.opacity(0.1))
                
                Button(action: {
                    print("Start over")
                }) {
                    Text("Start over")
                }.buttonStyle(GradientButtonStyle())
                
                Spacer()
            }.navigationBarTitle("Hiragana")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CheckMarkToggleStyle: ToggleStyle {
    var label = ""
    var color = Color.primary
    
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label)
            Spacer()
            Button(action: { configuration.isOn.toggle() } )
            {
                Image(systemName: configuration.isOn
                    ? "checkmark.square.fill"
                    : "square.fill")
                    .foregroundColor(color)
            }
        }
        .font(.title)
        .padding(.horizontal)
    }
}
