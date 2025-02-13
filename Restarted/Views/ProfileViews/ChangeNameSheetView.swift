//
//  ChangeNameSheetView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.12.2024.
//

import SwiftUI

struct ChangeNameSheetView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextField("New name", text: $viewModel.newNameHandler)
                .withTextFieldModifires()
            
            Button(action: {
                viewModel.changeUserName()
                dismiss()
            }, label: {
                Text("Save")
                    .withAnimatedButtonFormatting(viewModel.newNameHandler.isEmpty)
            })
            .disabled(viewModel.newNameHandler.isEmpty)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(Color.background)
    }
}

#Preview {
    ChangeNameSheetView()
        .environmentObject(ProfileViewModel())
}
