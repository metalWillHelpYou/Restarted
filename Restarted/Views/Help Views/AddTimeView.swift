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
            } label: {
                Text("Add")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.text)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .strokeBackground(Color.highlight)
                    .padding(.bottom, 36)
            }
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
            Text("Only if you forgot about stopwatch")
                .font(.caption)
        }
    }
}


#Preview {
    AddTimeView { _ in
        
    }
}
