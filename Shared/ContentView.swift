//
//  ContentView.swift
//  Shared
//
//  Created by Ben Buchanan on 1/7/22.
//

import SwiftUI

struct ContentView: View {
        
    var body: some View {
        TimerView(duration: 30)
    }
}

struct TimerView: View {
    
    @State var duration: Int
    @State var originalDuration: Int
    @State var timerActive: Bool
    
    init(duration: Int) {
        _duration = State(initialValue: duration)
        _originalDuration = State(initialValue: duration)
        _timerActive = State(initialValue: false)
    }
    
    var buttonColor = Color(red: 35 / 255, green: 35 / 255, blue: 35 / 255)
        
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                // Title and settings button
                HStack {
                    Text("Set Timer").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading).padding(20)
                    Button(action: {
                        // TODO: setup settings view
                        print("settings click")
                    }) {
                        ZStack {
                            Circle().fill(buttonColor).frame(width: 40, height: 40)
                            Image("settings").resizable().frame(width: 20, height: 20)
                        }
                    }.padding(20)
                }
                Spacer()
            }
                
            // Circle and Timer
            ZStack {
                Circle().fill(LinearGradient(gradient: Gradient(colors: [Color(red: 20 / 255, green: 30 / 255, blue: 215 / 255), Color(red: 140 / 255, green: 125 / 255, blue: 220 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 200, height: 200)
                Text("\(self.duration)").font(.system(size: 64)).fontWeight(.bold).foregroundColor(.white)
                    .onReceive(timer) { time in
                        if self.duration > 0 && self.timerActive {
                            self.duration -= 1
                        }
                    }
                    .onDisappear() {
                        self.timer.upstream.connect().cancel()
                    }
            }
            
            // TODO: setup progress bar
            
            // Stop, pause/resume, and repeat buttons
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        self.timerActive = false
                        self.duration = self.originalDuration
                    }) {
                        ZStack {
                            Circle().fill(buttonColor).frame(width: 60, height: 60)
                            Image("stop").resizable().frame(width: 20, height: 20)
                        }
                    }.padding()
                    Button(action: {
                        self.timerActive.toggle()
                    }) {
                        ZStack {
                            // TODO: make play button different color
                            Circle().fill(self.timerActive ? buttonColor : buttonColor).frame(width: 100, height: 100)
                            Image(self.timerActive ? "pause" : "play").resizable().frame(width: self.timerActive ? 30 : 35, height: 40)
                        }
                    }.padding()
                    Button(action: {
                        self.duration = self.originalDuration
                    }) {
                        ZStack {
                            Circle().fill(buttonColor).frame(width: 60, height: 60)
                            Image("restart").resizable().frame(width: 35, height: 35)
                        }
                    }.padding()
                }.padding(.bottom, 25)
            }
        }
    }
}








struct Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
