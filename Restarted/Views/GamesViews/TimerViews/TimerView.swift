//
//  TimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.08.2024.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var timerVM: TimerViewModel
    
    var game: Game?
    var hours: Int
    var minutes: Int
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .stroke(.white, lineWidth: 2)
                    .padding()
                
                VStack {
                    if let game = game {
                        Text("Game: \(game.title ?? "Unknown")")
                        Text(timerVM.timeString())
                            .font(.largeTitle)
                            .padding()
                    } else {
                        Text("Can't detect any game")
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
        .background(.black)
        .foregroundStyle(.white)
        .navigationBarBackButtonHidden(true)
        .onAppear { timerVM.startTimer(hours: hours, minutes: minutes) }
    }
}

extension TimerView {
    private var pauseButton: some View {
        Button(action: {
            if timerVM.isTimerRunning {
                timerVM.pauseTimer()
            } else {
                timerVM.resumeTimer()
            }
        }, label: {
            Text(timerVM.isTimerRunning ? "Pause" : "Start")
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
            timerVM.stopTimer()
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

#Preview {
    TimerView(game: nil, hours: 1, minutes: 30)
        .environmentObject(TimerViewModel())
}
