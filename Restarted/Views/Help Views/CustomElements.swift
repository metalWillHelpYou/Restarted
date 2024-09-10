//
//  CustomElements.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.09.2024.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(.leading, 8)
            .frame(height: 55)
            .foregroundStyle(.black)
            .background(Color.highlight.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct CustomButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .background(Color.highlight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
