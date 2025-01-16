//
//  SetUpTimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 18.08.2024.
//

import SwiftUI

struct SetUpTimerView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var showDeletePresetDialog: Bool = false
    @State private var presetToDelete: TimePresetFirestore?
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    var game: GameFirestore?
    var selectedPreset: TimePresetFirestore?
    
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .navigationTitle(gameTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { viewModel.savedPresets = [] }
        .onAppear {
            if let game = game {
                viewModel.selectedGameId = game.id
            }
        }
        .confirmationDialog(
            "Are you sure?",
            isPresented: $showDeletePresetDialog,
            titleVisibility: .visible
        ) {
            if let preset = presetToDelete, let game = game {
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deletePreset(with: preset.id, for: game.id)
                    }
                }
            }
        }
    }
}

extension SetUpTimerView {
    // MARK: - Computed Properties
    
    private var gameTitle: String {
        game?.title ?? "Unknown Game"
    }
    
    // MARK: - Subviews
    
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
            if !viewModel.savedPresets.isEmpty {
                Text("Recents")
                    .font(.headline)
                    .padding(.horizontal)
            }
            
            List {
                ForEach(viewModel.savedPresets.sorted(by: { $0.seconds > $1.seconds })) { preset in
                    let time = TimeTools.convertSecondsToTime(preset.seconds)
                    
                    NavigationLink(
                        destination: TimerView(
                            isTimerRunning: .constant(true),
                            game: game,
                            seconds: preset.seconds
                        ),
                        label: {
                            VStack(alignment: .leading) {
                                Text(TimeTools.formatTimeDigits(hours: time.hours, minutes: time.minutes))
                                    .font(.title)
                                    .padding(.vertical, 2)
                                
                                Text(TimeTools.formatTimeText(hours: time.hours, minutes: time.minutes))
                                    .font(.caption)
                                    .foregroundColor(.highlight.opacity(0.7))
                            }
                        }
                    )
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Delete") {
                            presetToDelete = preset
                            showDeletePresetDialog = true
                        }
                        .tint(.red)
                    }
                    .listRowBackground(Color.background)
                }
            }
            .listRowSeparatorTint(Color.highlight)
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
                    .foregroundStyle(isTimeSelected ? Color.text : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .strokeBackground(isTimeSelected ? Color.highlight : Color.gray)
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.3), value: hours + minutes)
            }
        )
        .disabled(!isTimeSelected)
        .simultaneousGesture(TapGesture().onEnded {
            if isTimeSelected {
                if let game = game {
                    Task {
                        try await GamePresetManager.shared.addPreset(forGameId: game.id, seconds: (hours * 3600) + (minutes * 60))
                    }
                }
            }
        })
    }
    
    // MARK: - Helpers
    
    private var isTimeSelected: Bool {
        hours > 0 || minutes > 0
    }
}

#Preview {
    SetUpTimerView()
        .environmentObject(TimerViewModel())
        .environmentObject(GameViewModel())
}
