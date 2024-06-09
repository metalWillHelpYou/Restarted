//
//  GoalAndPeriodView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 06.06.2024.
//

import SwiftUI

struct GoalAndPeriodView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @State private var inputText = ""
    @State private var selectedUnit: UnitOfMeasure = .m
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading) {
                Text("Goal")
                    .font(.title2).bold()
                
                HStack(spacing: 8) {
                    TextField("20", text: $inputText)
                        .keyboardType(.numberPad)
                        .frame(width: 65, height: 10)
                        .padding()
                        .cornerRadius(15)
                        .onChange(of: inputText) { newValue in
                            inputText = newValue.filter { "0123456789".contains($0) }
                            if inputText.count > 10 {
                                inputText = String(inputText.prefix(5))
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.highlight, lineWidth: 2)
                        )
                    //TODO: сделать отдельный модификатор из этого
                    
                    Picker("Select Unit", selection: $selectedUnit) {
                        ForEach(UnitOfMeasure.allCases) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 70, height: 42)
                    .cornerRadius(15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.highlight, lineWidth: 2)
                    )
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Period")
                    .font(.title2).bold()
                
                HStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 70, height: 40)
                        .foregroundStyle(Color.highlight)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 70, height: 40)
                        .foregroundStyle(Color.highlight)
                }
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    GoalAndPeriodView()
}
