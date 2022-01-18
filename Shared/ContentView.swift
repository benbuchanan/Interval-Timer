//
//  ContentView.swift
//  Shared
//
//  Created by Ben Buchanan on 1/7/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
        
    var body: some View {
        TimerView(duration: 30, rounds: 1, rest: 0)
    }
}

struct TimerView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var duration: Double
    @State var originalDuration: Double
    @State var timerActive: Bool
    @State var showSettings: Bool = false
    @State var offset: Double = 0.0
    @State var dragging: Bool = false
    @State var rounds: Double
    @State var rest: Double
    
    init(duration: Double, rounds: Double, rest: Double) {
        _duration = State(initialValue: duration)
        _originalDuration = State(initialValue: duration)
        _timerActive = State(initialValue: false)
        _rounds = State(initialValue: rounds)
        _rest = State(initialValue: rest)
    }
    
    var gradientButtonColor = LinearGradient(gradient: Gradient(colors: [Color(red: 20 / 255, green: 30 / 255, blue: 215 / 255), Color(red: 140 / 255, green: 125 / 255, blue: 220 / 255)]), startPoint: .bottomLeading, endPoint: .topTrailing)
    var darkGradientButtonColor = LinearGradient(gradient: Gradient(colors: [Color(red: 35 / 255, green: 35 / 255, blue: 35 / 255)]), startPoint: .center, endPoint: .center)
    var lightGradientButtonColor = LinearGradient(gradient: Gradient(colors: [Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255)]), startPoint: .center, endPoint: .center)
    var lightShadowColor = Color(red: 50 / 255, green: 50 / 255, blue: 50 / 255)
        
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .onChanged { value in
                self.dragging = true
                self.originalDuration = round(value.translation.width) > 0 ? round(value.translation.width / 2) : 0
                self.duration = self.originalDuration
            }
            .onEnded { _ in
                withAnimation {
                    self.dragging = false
                }
            }
        
        if showSettings {
            SettingsView(duration: $duration, rounds: $rounds, rest: $rest)
        } else {
            ZStack {
                VStack {
                    // Title and settings button
                    HStack {
                        Text("Set Timer").font(.largeTitle).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).padding(20)
                        Button(action: {
                            withAnimation(.spring()) {
                                self.showSettings = true
                            }
                        }) {
                            ZStack {
                                Circle().fill(darkGradientButtonColor).frame(width: 40, height: 40)
                                Image("settings").resizable().frame(width: 20, height: 20)
                            }
                        }.padding(20)
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rounds").foregroundColor(Color(red: 115 / 255, green: 115 / 255, blue: 115 / 255))
                            Text("\(Int(self.rounds))").font(.title).fontWeight(.bold)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Duration").foregroundColor(Color(red: 115 / 255, green: 115 / 255, blue: 115 / 255))
                            Text("\(Int(self.originalDuration))").font(.title).fontWeight(.bold)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Rest").foregroundColor(Color(red: 115 / 255, green: 115 / 255, blue: 115 / 255))
                            Text("\(Int(self.rest))").font(.title).fontWeight(.bold)
                        }
                    }.padding().padding(.trailing, 80)
                    Spacer()
                }
                
                // Circle and Timer
                ZStack {
                    Circle()
                        .fill(self.timerActive ? gradientButtonColor : darkGradientButtonColor)
                        .frame(width: 200, height: 200)
                        .scaleEffect(self.timerActive ? 1.2 : 1.0)
                        .animation(.linear(duration: 0.1), value: self.timerActive)
                        .shadow(color: colorScheme == .dark ? lightShadowColor : .gray, radius: self.timerActive ? 20 : 0)
                    Text("\(Int(self.duration))")
                        .font(.system(size: 64))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .onReceive(timer) { time in
                            if self.duration > 0 && self.timerActive {
                                self.duration -= 1
                            } else if self.timerActive {
                                AudioServicesPlaySystemSound(4095)
                                if self.rounds > 1 {
                                    self.duration = self.originalDuration
                                    self.rounds -= 1
                                } else {
                                    self.timerActive = false
                                    self.duration = self.originalDuration
                                }
                            }
                        }
                        .onDisappear() {
                            self.timer.upstream.connect().cancel()
                        }
                }.gesture(!self.timerActive ?
                    dragGesture : nil
                ).scaleEffect(self.dragging ? 1.3 : 1).animation(.easeInOut, value: self.dragging)
                        
                // Progress bar, stop, pause/resume, and repeat buttons
                VStack {
                    Spacer()
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 20).fill(colorScheme == .dark ? darkGradientButtonColor : lightGradientButtonColor).frame(width: 325, height: 2)
                        RoundedRectangle(cornerRadius: 20).fill(gradientButtonColor).frame(maxWidth: 325).frame(width: 325 * (self.duration / self.originalDuration), height: 2).animation(.linear(duration: 1), value: self.duration)
                    }
                    HStack {
                        Button(action: {
                            self.timerActive = false
                            self.duration = self.originalDuration
                        }) {
                            ZStack {
                                Circle()
                                    .fill(darkGradientButtonColor)
                                    .frame(width: 60, height: 60)
                                Image("stop")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }.padding()
                        Button(action: {
                            self.timerActive.toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(self.timerActive ? darkGradientButtonColor : gradientButtonColor)
                                    .frame(width: 100, height: 100)
                                    .shadow(color: colorScheme == .dark ? lightShadowColor : .gray, radius: self.timerActive ? 0 : 15)
                                Image(self.timerActive ? "pause" : "play")
                                    .resizable()
                                    .frame(width: self.timerActive ? 30 : 35, height: 40)
                            }
                        }.padding().buttonStyle(GradientBackgroundStyle()).disabled(self.duration == 0)
                        Button(action: {
                            self.duration = self.originalDuration
                        }) {
                            ZStack {
                                Circle()
                                    .fill(darkGradientButtonColor)
                                    .frame(width: 60, height: 60)
                                Image("restart")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                            }
                        }.padding()
                    }.padding(.bottom, 25)
                }
            }
        }
    }
}

struct SettingsView: View {
    
    @Binding var duration: Double
    @Binding var rounds: Double
    @Binding var rest: Double
    @State var showSettings: Bool = true
    
    var body: some View {
        if !showSettings {
            TimerView(duration: self.duration, rounds: self.rounds, rest: self.rest)
        } else {
            ZStack {
                VStack {
                    HStack {
                        Text("Settings").font(.largeTitle).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).padding(20)
                        Button(action: {
                            withAnimation(.spring()) {
                                self.showSettings = false
                            }
                        }) {
                            Text("Back")
                        }.padding(20)
                    }
                    Spacer()
                }
                VStack(spacing: 30) {
                    VStack(alignment: .leading) {
                        Text("Duration").font(.title).fontWeight(.bold)
                        Slider(value: $duration, in: 0...100, step: 1) {}
                        minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("100")
                        }.frame(width: 250)
                        Text("\(Int(self.duration)) seconds")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Rounds").font(.title).fontWeight(.bold)
                        Slider(value: $rounds, in: 0...10, step: 1) {}
                        minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("10")
                        }.frame(width: 250)
                        Text("\(Int(self.rounds)) rounds")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Rest").font(.title).fontWeight(.bold)
                        Slider(value: $rest, in: 0...60, step: 1) {}
                        minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("60")
                        }.frame(width: 250)
                        Text("\(Int(self.rest)) seconds")
                    }
                }
            }.transition(.move(edge: .trailing))
        }
    }
}



struct GradientBackgroundStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}








struct Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
    }
}
