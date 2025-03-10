//
//  AddTimeView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 15.01.2025.
//

import SwiftUI

struct AddTimeView: View {
    let onSave: (Int) -> ()
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            headerSection
            
            HStack {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour) h").tag(hour)
                            .foregroundStyle(Color.text)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute) m").tag(minute)
                            .foregroundStyle(Color.text)
                    }
                }
                .pickerStyle(.wheel)
            }
            
            Spacer()
            
            Button {
                let seconds = (hours * 3600) + (minutes * 60)
                onSave(seconds)
                HapticManager.instance.notification(type: .success)
                dismiss()
            } label: {
                Text("Add")
                    .withAnimatedButtonFormatting(!isTimeSelected)
                    .padding(.bottom, 36)
            }
            .disabled(!isTimeSelected)
        }
        .frame(maxHeight: .infinity)
        .padding()
        .background(Color.background)
    }
}

extension AddTimeView {
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Add extra time")
                .font(.title3)
            
            Text("Only if you forgot to log it manually")
                .foregroundStyle(Color.highlight)
                .multilineTextAlignment(.center)
        }
    }
    
    private var isTimeSelected: Bool {
        hours > 0 || minutes > 0
    }
}


#Preview {
    AddTimeView { _ in }
}

