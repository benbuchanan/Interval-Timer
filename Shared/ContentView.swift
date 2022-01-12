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
    @State var fill: CGFloat = 0
        
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                // Title and settings button
                HStack {
                    Text("Set Timer").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading).padding(20)
                    Button("-Settings-") {
                        print("settings click")
                    }.padding(20)
                }
                Spacer()
            }
                
            // Circle and Timer
            ZStack {
                Circle().fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .bottomLeading, endPoint: .topTrailing)).frame(width: 200, height: 200)
                Text("\(self.duration)").font(.system(size: 64)).fontWeight(.bold).foregroundColor(.white)
                    .onReceive(timer) { time in
                        if self.duration > 0 {
                            self.duration -= 1
                        }
                    }
                    .onDisappear() {
                        self.timer.upstream.connect().cancel()
                    }
            }.onAppear() {
                self.fill = 1.0
            }
            
            // Stop, pause/resume, and repeat buttons
            // TODO: make buttons images of stop, pause/play, and repeat arrow
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        print("stop")
                    }) {
                        Text("stop")
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .background(.gray)
                            .clipShape(Circle())
                    }.padding()
                    Button(action: {
                        print("pause/resume")
                    }) {
                        Text("pause/resume")
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .background(.gray)
                            .clipShape(Circle())
                    }.padding()
                    Button(action: {
                        print("restart")
                    }) {
                        Text("restart")
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .background(.gray)
                            .clipShape(Circle())
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
