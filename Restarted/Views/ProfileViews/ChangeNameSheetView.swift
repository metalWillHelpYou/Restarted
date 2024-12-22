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
                .padding(.leading, 8)
                .frame(height: 55)
                .foregroundStyle(.black)
                .background(Color.highlight.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button(action: {
                viewModel.changeUserName()
                dismiss()
            }, label: {
                Text("Save")
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.text)
                    .strokeBackground(Color.highlight)
            })
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
