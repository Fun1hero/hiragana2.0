//
//  ContentView.swift
//  Hiragana 2.0
//
//  Created by dkab on 8/7/20.
//  Copyright © 2020 dkab. All rights reserved.
//

import SwiftUI

extension Color {
    static let offWhite = Color.init(red: 225/255, green: 225/255, blue: 235/255)
}

struct NeuroButtonStyle: ButtonStyle {
    @State var width: CGFloat
    @State var height: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.offWhite)
                    .frame(width: self.width, height: self.height)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        )
    }
}


struct ContentView: View {
    let hiraganaSequence = ["a","i","u","e","o","ka","ki","ku","ke","ko","sa","shi","su","se","so","ta","chi","tsu","te","to","na","hi","fu","he","ho","ma","mi","mu","me","mo","ya","yu","yo","ra","ri","ru","re","ro","wa","wo","n"]
    let hiraganaSequenceToRead = ["あ","い","う","え","お","か","き","く","け","こ","さ","し","す","せ","そ","た","ち","つ","て","と","な","ひ","ふ","へ","ほ","ま","み","む","め","も","や","ゆ","よ","ら","り","る","れ","ろ","わ","を","ん"]
    
    @State var inOrder :Bool = true;
    @State var challange :Bool = false;
    @State var spelling :Bool = false;
    
    @State var selectedKana :Int = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    
    func nextKana(next: Bool)
    {
        if (self.inOrder){
            if(next){
                if (self.selectedKana > 0){
                    self.selectedKana -= 1
                }
            } else {
                if (self.selectedKana < self.hiraganaSequence.capacity-1){
                    self.selectedKana += 1
                }
            }
        } else {
            self.selectedKana =  Int.random(in: 0..<self.hiraganaSequence.capacity-1)
        }
    }
    
    var body: some View {
        ZStack {
            Color.offWhite
            //        NavigationView {
            
            VStack (spacing: 40) {
                HStack (spacing: 50){
                    Button(action: {
                        self.nextKana(next: true)
                    }){
                        Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
//                        Image(systemName: "play.fill").rotationEffect(.degrees(180))
                    }.buttonStyle(NeuroButtonStyle(width: 60, height: 250))
                    
                    
                    Button(action: {print("play voice")}){
                        Text(self.hiraganaSequenceToRead[self.selectedKana])
                            .font(.system(size: 130, weight: .light))
                            .foregroundColor(.gray)
                    }.buttonStyle(NeuroButtonStyle(width: 200, height: 250))
                    
                    Button(action: {
                        self.nextKana(next: false)
                    }){
                        Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                    }.buttonStyle(NeuroButtonStyle(width: 60, height: 250))
                }
                
                
                
                Text(self.hiraganaSequence[self.selectedKana])
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.gray)

                
                HStack (spacing: 20){
                    Button(action: {
                        self.inOrder.toggle()
                    }){
                        Image(systemName: "textformat.abc.dottedunderline")
                    }
                    
                    Button(action: {
                        print("order")
                        
                    }){
                        Image(systemName: "studentdesk")
                    }
                    
                    
                    Button(action: {
                        print("order")
                        
                    }){
                        Image(systemName: "speaker.2.fill")
                    }
                    
                    Button(action: {
                        self.selectedKana = 0
                    }){
                        Image(systemName: "gobackward")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                
                
            }.navigationBarTitle("Hiragana")
        }.edgesIgnoringSafeArea(.all)
        //        }
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


