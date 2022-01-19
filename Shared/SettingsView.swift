//
//  SettingsView.swift
//  Workout Rest Timer
//
//  Created by Ben Buchanan on 1/18/22.
//

import SwiftUI

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
