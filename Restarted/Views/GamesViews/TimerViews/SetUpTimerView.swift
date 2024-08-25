//
//  SetUpTimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 18.08.2024.
//

import SwiftUI

import SwiftUI

struct SetUpTimerView: View {
    @EnvironmentObject var gameEntityVm: GameEntityViewModel
    @EnvironmentObject var alerts: AlertsManager
    @EnvironmentObject var timerVm: TimerViewModel
    var game: Game?
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Set Time for \(gameTitle)")
                    .font(.title)
                    .padding(.bottom)
                
                timePickers
                
                Spacer()
                
                startButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { saveTimeButton }
            }
            .alert(isPresented: $showAlert) { alerts.getSuccsesSaving() }
            .onAppear { initializeTime() }
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
                ForEach(0..<61) { minute in
                    Text("\(minute) m").tag(minute)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
        .padding(.horizontal)
    }
    
    private var startButton: some View {
        NavigationLink(
            destination: TimerView(game: game, hours: hours, minutes: minutes),
            label: {
                Text("Start")
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(hours > 0 || minutes > 0 ? Color.highlight : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.3), value: hours + minutes)
            }
        )
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


#Preview {
    SetUpTimerView()
        .environmentObject(GameEntityViewModel())
        .environmentObject(TimerViewModel())
}
