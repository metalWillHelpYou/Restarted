//
//  SetGameTimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 23.05.2024.
//

import SwiftUI

struct SetGameTimerView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @State private var isTimerActive = false
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Set Timer")
                    .font(.largeTitle)
                    .padding(.top, 20)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.highlight, lineWidth: 2)
                        .padding(.vertical, 80)
                    
                    
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
                    isTimerActive = true
                    print("Timer set for: \(selectedHours) hours, \(selectedMinutes) minutes,")
                }) {
                    Text("Save")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.highlight)
                        .foregroundColor(userTheme == .light ? .white : .black)
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal)
            .background(Color.background)
            .navigationDestination(isPresented: $isTimerActive, destination: {
                TimerView()
            })
        }
    }
}

#Preview {
    SetGameTimerView()
}
