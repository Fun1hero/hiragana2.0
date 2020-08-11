//
//  ContentView.swift
//  Hiragana 2.0
//
//  Created by dkab on 8/7/20.
//  Copyright © 2020 dkab. All rights reserved.
//

import SwiftUI
import AVFoundation

extension Color {
    static let offWhite = Color.init(red: 225/255, green: 225/255, blue: 235/255)
    
    static let darkStart = Color.init(red: 50/255, green: 60/255, blue: 65/255)
    static let darkEnd = Color.init(red: 25/255, green: 25/255, blue: 30/255)
    
    static let accentColor = Color.init(red: 90/255, green: 185/255, blue: 234/255)
    static let accentColorPurple = Color.init(red: 151/255, green: 96/255, blue: 208/255)
    
}

struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                    .overlay(shape.stroke(LinearGradient(Color.darkStart, Color.darkEnd), lineWidth: 2))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(Color.darkEnd, lineWidth: 2))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct LightBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(Color.offWhite)
                    .overlay(
                        shape
                            .stroke(Color.gray, lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: 2, y:2)
                            .mask(
                                shape.fill(LinearGradient(Color.black, Color.clear))
                        )
                        
                    )
                    .overlay(
                        shape
                            .stroke(Color.white, lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: -2, y:-2)
                            .mask(
                                shape.fill(LinearGradient(Color.clear, Color.black))
                        )
                    )
            } else {
                shape
                    .fill(Color.offWhite)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            }
        }
    }
}


extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .bottomTrailing)
    }
}

struct NeuroButtonStyle: ButtonStyle {
    @State var width: CGFloat
    @State var height: CGFloat
    @State var style: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .frame(width: self.width, height: self.height)
            .contentShape(RoundedRectangle(cornerRadius: 25))
            
            .background(
                Group {
                    if style {
                        DarkBackground(isHighlighted: configuration.isPressed, shape: RoundedRectangle(cornerRadius: 25))
                            .frame(width: self.width, height: self.height)
                    } else {
                        LightBackground(isHighlighted: configuration.isPressed, shape: RoundedRectangle(cornerRadius: 25))
                            .frame(width: self.width, height: self.height)
                    }
                }
        )
    }
}

struct NeuroButtonCircleStyle: ButtonStyle {
    @State var pressed: Bool?
    @State var style: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .contentShape(Circle())
            .background(
                Group {
                    if style {
                        DarkBackground(isHighlighted: self.pressed ?? configuration.isPressed, shape: Circle())
                    } else {
                        LightBackground(isHighlighted: self.pressed ?? configuration.isPressed, shape: Circle())
                    }
                }
        )
    }
}


struct ContentView: View {
    let hiraganaSequence = ["a","i","u","e","o","ka","ki","ku","ke","ko","sa","shi","su","se","so","ta","chi","tsu","te","to","na","hi","fu","he","ho","ma","mi","mu","me","mo","ya","yu","yo","ra","ri","ru","re","ro","wa","wo","n"]
    let hiraganaSequenceToRead = ["あ","い","う","え","お","か","き","く","け","こ","さ","し","す","せ","そ","た","ち","つ","て","と","な","ひ","ふ","へ","ほ","ま","み","む","め","も","や","ゆ","よ","ら","り","る","れ","ろ","わ","を","ん"]
    
    @State var inOrder :Bool = true;
    @State var challange :Bool = false;
    @State var spelling :Bool = true;
    
    @State var selectedKana :Int = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    
    let synthesizer = AVSpeechSynthesizer()
    
    func spellKana(){
        let utterance = AVSpeechUtterance(string: self.hiraganaSequenceToRead[self.selectedKana])
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = 0.2
        utterance.volume = 1.4
        
        if self.synthesizer.isSpeaking {
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary(rawValue: 0)!)
        } else {
            self.synthesizer.speak(utterance)
        }
    }
    
    func nextKana(next: Bool)
    {
        if (self.inOrder){
            if(next){
                if (self.selectedKana < self.hiraganaSequence.capacity-1){
                    self.selectedKana += 1
                } else {
                    self.selectedKana = 0
                }
            } else {
                if (self.selectedKana > 0){
                    self.selectedKana -= 1
                } else {
                    self.selectedKana = self.hiraganaSequence.capacity-1
                }
            }
        } else {
            self.selectedKana =  Int.random(in: 0..<self.hiraganaSequence.capacity-1)
        }
    }
    
    var body: some View {
        ZStack {
            
            if colorScheme == .dark {
                LinearGradient(.darkStart, .darkEnd)
            } else {
                Color.offWhite
            }
            
            VStack (spacing: 30) {
                HStack (spacing: 30){
                    Button(action: {
                        self.nextKana(next: false)
                        if self.spelling {
                            self.spellKana()
                        }
                    }){
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                    }.buttonStyle(NeuroButtonStyle(width: 60, height: 250, style: colorScheme == .dark))
                    
                    
                    Button(action: {
                        if self.spelling {
                            self.spellKana()
                        }
                    }){
                        Text(self.hiraganaSequenceToRead[self.selectedKana])
                            .font(.system(size: 130, weight: .light))
                            .foregroundColor(.accentColor)
                    }.buttonStyle(NeuroButtonStyle(width: 200, height: 250, style: colorScheme == .dark))
                    
                    Button(action: {
                        self.nextKana(next: true)
                        if self.spelling {
                            self.spellKana()
                        }
                    }){
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }.buttonStyle(NeuroButtonStyle(width: 60, height: 250, style: colorScheme == .dark))
                }
                
                
                Text(self.challange ? " " : self.hiraganaSequence[self.selectedKana])
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(.gray)
                    .padding(.top, 40)
                
                HStack (spacing: 30){
                    Button(action: {
                        self.inOrder.toggle()
                    }){
                        Image(systemName: "textformat.abc.dottedunderline")
                            .foregroundColor(.accentColorPurple)
                    }.buttonStyle(NeuroButtonCircleStyle(pressed: !self.inOrder, style: colorScheme == .dark))
                    
                    Button(action: {
                        print("challange")
                        self.challange.toggle()
                        self.spelling = false
                        
                    }){
                        Image(systemName: "studentdesk")
                            .foregroundColor(.accentColorPurple)
                    }.buttonStyle(NeuroButtonCircleStyle(pressed: self.challange, style: colorScheme == .dark))
                    
                    
                    Button(action: {
                        if self.challange {
                            self.spelling = false
                        } else {
                            self.spelling.toggle()
                        }
                    }){
                        Image(systemName: "speaker.2.fill")
                            .foregroundColor(.accentColorPurple)
                    }.buttonStyle(NeuroButtonCircleStyle(pressed: spelling, style: colorScheme == .dark))
                    
                    Button(action: {
                        self.selectedKana = 0
                        if self.spelling {
                            self.spellKana()
                        }
                    }){
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.accentColorPurple)
                    }.buttonStyle(NeuroButtonCircleStyle(style: colorScheme == .dark))
                }
                .padding()
                
                
            }.navigationBarTitle("Hiragana")
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



