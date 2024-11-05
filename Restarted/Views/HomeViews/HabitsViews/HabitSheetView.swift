//
//  HabitSheetView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 05.06.2024.
//

import SwiftUI

struct HabitSheetView: View {
    @EnvironmentObject var habitVm: HabitViewModel
    @Environment(\.dismiss) var dismiss
    @State private var habitTitle: String = ""
    @State private var goalText: String = ""
    @Binding var sheetModel: HabitSheetModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            CustomTextField(placeholder: sheetModel.titleText, text: $habitTitle)
            
            HStack {
                Text("Time goal")
                    .font(.title2).bold()
                
                Spacer()
                
                Text("Period")
                    .font(.title2).bold()
            }
            
            HStack {
                CustomTextField(placeholder: sheetModel.goalText, text: $goalText)
                    .keyboardType(.numberPad)
                
                Spacer()
                
                Menu("Select period") {
                    Button("Day") { /* handle selection */ }
                    Button("Week") { /* handle selection */ }
                }
            }
            
            Spacer()
            
            mainButton
        }
        .padding()
        .background(Color.background)
        .onTapGesture { self.hideKeyboard() }
        .onAppear {
            habitTitle = sheetModel.habit?.title ?? ""
            goalText = sheetModel.habit != nil ? String(sheetModel.habit?.goal ?? 0) : ""
        }
    }
}

extension HabitSheetView {
    private var mainButton: some View {
        Button(action: {
            habitVm.handleButtonAction(
                sheetModel: sheetModel, 
                habitTitle: habitTitle,
                goal: goalText,
                dismiss: {
                    habitTitle = ""
                    goalText = ""
                    dismiss()
                }
            )
        }, label: {
            Text(sheetModel.buttonLabel)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundStyle(habitTitle.isEmpty && goalText.isEmpty ? Color.gray : Color.text)
                .strokeBackground(habitTitle.isEmpty && goalText.isEmpty ? Color.gray : Color.highlight)
        })
        .disabled(habitTitle.isEmpty && goalText.isEmpty)
    }
}


#Preview {
    HabitSheetView(sheetModel: .constant(HabitSheetModel(titleText: "", goalText: "", buttonLabel: "", buttonType: .add)))
        .environmentObject(HabitViewModel())
}
