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
    var practice: Practice
    
    var body: some View {
        VStack {
            Spacer()
            
            practiceTitle
            
            stopwatchTime
            
            Spacer()
            
            buttonSection
        }
        .padding()
        .foregroundStyle(Color.white)
        .background(Color.black)
        .onAppear {
            viewModel.startStopwatch(forPracticeId: practice.id)
        }
    }
}

extension StopwatchView {
    private var practiceTitle: some View {
        Text(practice.title)
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
            viewModel.stopStopwatch(forPracticeId: practice.id)
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
            viewModel.isStopwatchRunning ? viewModel.pauseStopwatch() : viewModel.startStopwatch(forPracticeId: practice.id)
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
