//
//  SetGameTimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 23.05.2024.
//

import SwiftUI

struct SetGameTimerView: View {
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    
    var body: some View {
        VStack {
            Text("Set Timer")
                .font(.largeTitle)
                .padding(.top, 20)
            
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .stroke(ThemeColors.light.tabBarColor, lineWidth: 2) // Контур синего цвета
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.6)))
                    .padding()
                    .padding(.horizontal, 4)
                
                
                HStack(spacing: 20) {
                    VStack {
                        Picker("Hours", selection: $selectedHours) {
                            ForEach(0..<5) { hour in
                                Text("\(hour) h").tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 100)
                    }
                    
                    VStack {
                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute) m").tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 100)
                    }
                }
                .padding(.top, 40)
            }
            
            Spacer()
            
            Button(action: {
                print("Timer set for: \(selectedHours) hours, \(selectedMinutes) minutes,")
            }) {
                Text("Save")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ThemeColors.light.tabBarColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(ThemeColors.light.backgroundColor)
    }
}

#Preview {
    SetGameTimerView()
}
