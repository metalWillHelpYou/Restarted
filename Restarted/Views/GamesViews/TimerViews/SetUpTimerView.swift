//
//  SetUpTimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 18.08.2024.
//

import SwiftUI

struct SetUpTimerView: View {
    @EnvironmentObject var gameEntityVm: GameEntityViewModel
    @EnvironmentObject var alerts: AlertsManager
    var game: Game? // <- Если в этом файле будут проблемы, скорее всего причина тут
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Set Time for \(gameTitle)")
                    .font(.title)
                
                timePickers
                
                Spacer()
                
                startButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    saveTimeButton
                }
            }
            .alert(isPresented: $showAlert) {
                alerts.getSuccsesSaving()
            }
            .onAppear {
                initializeTime()
            }
        }
    }
}

extension SetUpTimerView {
    private var gameTitle: String {
        game?.title ?? "Game"
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
        Button(action: {
        }, label: {
            Text("Start")
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(Color.highlight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
        })
    }
    
    private func initializeTime() {
        hours = Int(game?.hours ?? 0)
        minutes = Int(game?.minutes ?? 0)
    }
    
    private var saveTimeButton: some View {
        Button(action: {
            gameEntityVm.saveTime(
                game: game,
                hours: hours,
                minutes: minutes
            )
            showAlert.toggle()
        }, label: {
            Text("Save time")
        })
    }
}


#Preview {
    SetUpTimerView()
        .environmentObject(GameEntityViewModel())
}
