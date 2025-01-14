//
//  StopwatchView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 13.01.2025.
//

import SwiftUI

struct StopwatchView: View {
    @StateObject private var viewModel = StopwatchViewModel()
    @Environment(\.dismiss) var dismiss
    var habit: HabitFirestore
    
    var body: some View {
        VStack {
            Spacer()
            
            habitTitle
            
            stopwatchTime
            
            Spacer()
            
            buttonSection
        }
        .padding()
        .foregroundStyle(Color.white)
        .background(Color.black)
        .onAppear {
            viewModel.startStopwatch(forHabitId: habit.id)
        }
    }
}

extension StopwatchView {
    private var habitTitle: some View {
        Text(habit.title)
            .font(.headline)
    }
    
    private var stopwatchTime: some View {
        Text(viewModel.formattedTime())
            .font(.largeTitle)
            .padding()
    }
    
    private var buttonSection: some View {
        HStack {
            resetButton
            
            toggleButton
        }
    }
    
    private var resetButton: some View {
        Button {
            viewModel.stopStopwatch(forHabitId: habit.id)
            dismiss()
        } label: {
            Text("Reset")
                .foregroundStyle(Color.white)
                .padding()
                .padding(.horizontal)
                .frame(height: 55)
                .strokeBackground(Color.red)
        }
    }
    
    private var toggleButton: some View {
        Button(action: {
            viewModel.isStopwatchRunning ? viewModel.pauseStopwatch() : viewModel.startStopwatch(forHabitId: habit.id)
        }) {
            Text(viewModel.isStopwatchRunning ? "Pause" : "Resume")
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding()
                .padding(.horizontal)
                .frame(height: 55)
                .strokeBackground(Color.white)
        }
    }
}
