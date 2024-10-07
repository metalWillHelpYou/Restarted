//
//  SetUpTimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 18.08.2024.
//

import SwiftUI

struct SetUpTimerView: View {
    @EnvironmentObject var gameEntityVm: GameViewModel
    @EnvironmentObject var alerts: AlertsManager
    @EnvironmentObject var timerVm: TimerViewModel
    var game: Game?
    @Binding var navigationPath: NavigationPath
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var showAlert: Bool = false
    @State private var isTimerRunning: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isTimerRunning {
                    TimerView(navigationPath: $navigationPath, isTimerRunning: $isTimerRunning, game: game, hours: hours, minutes: minutes)
                        .transition(.move(edge: .trailing))
                } else {
                    VStack {
                        Spacer()
                        
                        Text("Set Time for \(gameTitle)")
                            .font(.title)
                            .padding(.bottom)
                        
                        timePickers
                        
                        Spacer()
                        
                        startButton
                    }
                    .transition(.move(edge: .leading))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .toolbar {
                if !isTimerRunning {
                    ToolbarItem(placement: .topBarTrailing) { saveTimeButton }
                }
            }
            .alert(isPresented: $showAlert) { alerts.getSuccsesSaving() }
            .onAppear { initializeTime() }
            .animation(.easeInOut(duration: 0.5), value: isTimerRunning)
        }
    }
}

extension SetUpTimerView {
    private var gameTitle: String {
        game?.title ?? "Unknown Game"
    }
    
    private var timePickers: some View {
        HStack(spacing: 20) {
            Picker("Hours", selection: $hours) {
                ForEach(0..<13) { hour in
                    Text("\(hour) h").tag(hour)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            Picker("Minutes", selection: $minutes) {
                ForEach(0..<60) { minute in
                    Text("\(minute) m").tag(minute)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
        .padding(.horizontal)
    }
    
    private var startButton: some View {
        Button(action: {
            if hours > 0 || minutes > 0 {
                isTimerRunning = true
            }
        }) {
            Text("Start")
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .background(hours > 0 || minutes > 0 ? Color.highlight : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .animation(.easeInOut(duration: 0.3), value: hours + minutes)
        }
        .disabled(hours == 0 && minutes == 0)
    }
    
    private var saveTimeButton: some View {
        Button(action: {
            guard let game = game else { return }
            gameEntityVm.saveTime(game: game, hours: hours, minutes: minutes)
            showAlert.toggle()
        }, label: {
            Text("Save time")
        })
    }
    
    private func initializeTime() {
        guard let game = game else { return }
        hours = Int(game.hours)
        minutes = Int(game.minutes)
    }
}

struct TimerView: View {
    @Environment(\.dismiss) var dismiss
   
    @EnvironmentObject var timerVM: TimerViewModel
    @State private var showStopDialog: Bool = false
    @Binding var navigationPath: NavigationPath
    @Binding var isTimerRunning: Bool
    
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
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

#Preview {
    SetUpTimerView(navigationPath: .constant(NavigationPath()))
        .environmentObject(GameViewModel())
        .environmentObject(TimerViewModel())
        .environmentObject(AlertsManager())
}
