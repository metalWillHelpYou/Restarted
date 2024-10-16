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
    @StateObject var notificationManager = LocalNotificationManager()
    @Binding var isTimerRunning: Bool
    @State private var isStatusLineAppeared: Bool = false
    
    var game: Game?
    var seconds: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 5)
                    .padding()
                
                Circle()
                    .trim(from: 0, to: circleProgress)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(isStatusLineAppeared ? .linear(duration: 1) : .none, value: circleProgress)
                    .padding()
                
                VStack {
                    if let gameTitle = game?.title {
                        Text(gameTitle)
                            .font(.headline)
                            .padding(.bottom, 5)
                    } else {
                        Text("No game selected")
                            .font(.headline)
                    }
                    
                    Text(timerVM.timeString())
                        .font(.largeTitle)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            
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
                timerVM.startTimer(seconds: seconds)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isStatusLineAppeared = true
            }
            
            Task {
                await notificationManager.scheduleTimerEndedNotification(duration: TimeInterval(seconds))
            }
            timerVM.onTimerEnded = {
                dismiss()
            }
        }
        .confirmationDialog("Are you sure to stop the timer?", isPresented: $showStopDialog, titleVisibility: .visible) {
            stopConfirmationButtons
        }
    }
}

extension TimerView {
    private var circleProgress: CGFloat {
        return seconds > 0 ? CGFloat(timerVM.timeRemaining) / CGFloat(seconds) : 0
    }
    
    private var pauseButton: some View {
        Button(action: {
            timerVM.isTimerRunning ? timerVM.pauseTimer() : timerVM.resumeTimer()
        }, label: {
            Text(timerVM.isTimerRunning ? "Pause" : "Resume")
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding()
                .padding(.horizontal)
                .frame(height: 55)
                .strokeBackground(Color.white)
        })
    }
    
    private var stopButton: some View {
        Button(action: {
            showStopDialog.toggle()
        }, label: {
            Text("Stop")
                .foregroundStyle(Color.white)
                .padding()
                .padding(.horizontal)
                .frame(height: 55)
                .strokeBackground(Color.red)
        })
    }
    
    private var stopConfirmationButtons: some View {
        Group {
            Button("Stop", role: .destructive) {
                timerVM.stopTimer()
                isTimerRunning = false
                
                notificationManager.removeRequest(withIdentifier: "TimerEnded")
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

#Preview {
    TimerView(isTimerRunning: .constant(true), game: nil, seconds: 600)
        .environmentObject(TimerViewModel())
}
