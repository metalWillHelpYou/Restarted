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
    @StateObject var notificationManager = LocalNotificationManager() // Менеджер уведомлений
    @Binding var navigationPath: NavigationPath
    @Binding var isTimerRunning: Bool
    @State private var isStatusLineAppeared: Bool = false
    
    var game: Game?
    var hours: Int
    var minutes: Int
    
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
                timerVM.startTimer(hours: hours, minutes: minutes)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isStatusLineAppeared = true
            }
            
            Task {
                await notificationManager.scheduleTimerEndedNotification(duration: TimeInterval(hours * 3600 + minutes * 60))
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
        let totalTime = (hours * 3600) + (minutes * 60)
        return totalTime > 0 ? CGFloat(timerVM.timeRemaining) / CGFloat(totalTime) : 0
    }
    
    private var pauseButton: some View {
        CustomButton(
            title: timerVM.isTimerRunning ? "Pause" : "Resume",
            action: timerVM.isTimerRunning ? timerVM.pauseTimer : timerVM.resumeTimer
        )
    }
    
    private var stopButton: some View {
        Button(action: {
            showStopDialog.toggle()
        }, label: {
            Text("Stop")
                .font(.headline)
                .padding()
                .padding(.horizontal)
                .frame(height: 55)
                .foregroundStyle(.black)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        })
    }
    
    private var stopConfirmationButtons: some View {
        Group {
            Button("Stop", role: .destructive) {
                timerVM.stopTimer()
                isTimerRunning = false
                
                // Удаляем запланированное уведомление при остановке таймера
                notificationManager.removeRequest(withIdentifier: "TimerEnded")
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}


#Preview {
    TimerView(navigationPath: .constant(NavigationPath()), isTimerRunning: .constant(true),game: nil, hours: 1, minutes: 30)
        .environmentObject(TimerViewModel())
}
