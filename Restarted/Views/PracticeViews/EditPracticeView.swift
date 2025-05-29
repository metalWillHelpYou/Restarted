//
//  EditPracticeView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 29.05.2025.
//

import SwiftUI

struct EditPracticeView: View {
    @EnvironmentObject var viewModel: PracticeViewModel
    @Environment (\.dismiss) var dismiss
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    let practice: Practice
    
    var body: some View {
        VStack {
            TextField("Edit practice", text: $viewModel.practiceTitleInput)
                .withTextFieldModifires()
            
            Button(action: {
                Task {
                    await viewModel.editPractice(practice.id, title: viewModel.practiceTitleInput)
                }
                HapticManager.instance.notification(type: .success)
                dismiss()
            }, label: {
                Text("Save")
                    .withAnimatedButtonFormatting(viewModel.practiceTitleInput.isEmpty)
            })
            .disabled(viewModel.practiceTitleInput.isEmpty)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.background)
    }
}
