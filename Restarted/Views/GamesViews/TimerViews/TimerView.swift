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
    @State private var showStopDialog: Bool = false
    
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
                    if game != nil {
                        Text("Now you're playing: \(gameTitle)")
                        Text(timerVM.timeString())
                            .font(.largeTitle)
                            .padding()
                    } else {
                        Text("No game selected")
                            .font(.headline)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                stopButton
                pauseButton
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .foregroundStyle(.white)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if game != nil {
                timerVM.startTimer(hours: hours, minutes: minutes)
            }
        }
        .confirmationDialog("Are you sure to stop the timer?", isPresented: $showStopDialog, titleVisibility: .visible) {
            stopConfirmationButtons
        }
    }
}

extension TimerView {
    private var gameTitle: String {
        game?.title ?? "Unknown"
    }
    
    private var pauseButton: some View {
        Button(action: {
            if timerVM.isTimerRunning {
                timerVM.pauseTimer()
            } else {
                timerVM.resumeTimer()
            }
        }, label: {
            Text(timerVM.isTimerRunning ? "Pause" : "Resume")
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
            showStopDialog.toggle()
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
    
    private var stopConfirmationButtons: some View {
        Group {
            Button("Stop", role: .destructive) {
                timerVM.stopTimer()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

#Preview {
    TimerView(game: nil, hours: 1, minutes: 30)
        .environmentObject(TimerViewModel())
}
