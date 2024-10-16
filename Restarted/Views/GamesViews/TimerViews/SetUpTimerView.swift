//
//  SetUpTimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 18.08.2024.
//

import SwiftUI

struct SetUpTimerView: View {
    @EnvironmentObject var timerVm: TimerViewModel
    var game: Game?
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    timePickers
                    
                    savedTimesList
                    
                    Spacer()
                    
                    startButton
                }
                .transition(.move(edge: .leading))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .navigationTitle(gameTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                timerVm.fetchPresets()
                hours = 0
                minutes = 0
            }
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
    
    private var savedTimesList: some View {
        VStack(alignment: .leading) {
            if !timerVm.savedPresets.isEmpty {
                Text("Recents")
                    .font(.headline)
                    .padding(.horizontal)
            }
            
            List {
                ForEach(timerVm.savedPresets, id: \.self) { preset in
                    HStack {
                        let time = timerVm.convertSecondsToTime(Int(preset.seconds))
                        
                        VStack(alignment: .leading) {
                            Text(timerVm.formatTimeDigits(hours: time.hours, minutes: time.minutes))
                                .font(.title)
                                .padding(.vertical, 2)
                            
                            Text(timerVm.formatTimeText(hours: time.hours, minutes: time.minutes))
                                .font(.caption)
                                .foregroundColor(.highlight.opacity(0.7))
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Delete") {
                            withAnimation(.easeInOut(duration: 0.5)){
                                timerVm.deletePreset(preset)
                            }
                        }
                        .tint(.red)
                    }
                    .listRowBackground(Color.background)
                }
                .listRowSeparatorTint(Color.highlight)
            }
            .listStyle(PlainListStyle())
            .offset(y: -2)
        }
    }
    
    private var startButton: some View {
        NavigationLink(
            destination: {
                let totalSeconds = (hours * 3600) + (minutes * 60)
                TimerView(isTimerRunning: .constant(true), game: game, seconds: totalSeconds)
            },
            label: {
                Text("Start")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(hours > 0 || minutes > 0 ? Color.text : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .strokeBackground(hours > 0 || minutes > 0 ? Color.highlight : Color.gray)
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.3), value: hours + minutes)
            }
        )
        .disabled(hours == 0 && minutes == 0)
        .simultaneousGesture(TapGesture().onEnded {
            if hours > 0 || minutes > 0 {
                let totalSeconds = (hours * 3600) + (minutes * 60)
                timerVm.saveTime(seconds: totalSeconds)
            }
        })
    }
}

#Preview {
    SetUpTimerView()
        .environmentObject(TimerViewModel())
}
