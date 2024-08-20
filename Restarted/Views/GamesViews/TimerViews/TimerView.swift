//
//  TimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.08.2024.
//

import SwiftUI
import CoreData
import Combine

struct TimerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var timerSubscription: AnyCancellable?
    @State private var timeRemaining: Int = 0
    @State private var isTimerRunning: Bool = false
    
    var game: Game?
    var hours: Int
    var minutes: Int
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .stroke(.white, lineWidth: 2)
                
                VStack {
                    if let game = game {
                        Text("Game: \(game.title ?? "Unknown")")
                        Text("\(timeString(time: timeRemaining))")
                            .font(.largeTitle)
                            .padding()
                    } else {
                        Text("Now you're playng: Dota")
                        Text("10:32:22")
                            .font(.largeTitle)
                            .padding()
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                stopButton
                pauseButton
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.black)
        .foregroundStyle(.white)
        .navigationBarBackButtonHidden(true)
        .onAppear { startTimer() }
    }
    // переместить
    private func startTimer() {
        timeRemaining = (hours * 3600) + (minutes * 60)
        
        timerSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timerSubscription?.cancel()
                }
            }
    }
    // переместить
    private func timeString(time: Int) -> String {
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    TimerView(game: nil, hours: 1, minutes: 30)
}


extension TimerView {
    private var pauseButton: some View {
        Button(action: {
            isTimerRunning.toggle()
        }, label: {
            Text(isTimerRunning ? "Pause" : "Start")
                .frame(maxWidth: .infinity)
                .padding()
                .padding(.horizontal)
                .background(Color.highlight)
                .foregroundColor(.text)
                .font(.headline)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        })
    }
    
    private var stopButton: some View {
        Button(action: {
            timerSubscription?.cancel()
            dismiss()
        }, label: {
            Text("Stop")
                .padding()
                .padding(.horizontal)
                .background(Color.red)
                .foregroundStyle(.black)
                .font(.headline)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        })
    }
}
