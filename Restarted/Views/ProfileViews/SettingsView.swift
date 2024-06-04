//
//  SettingsView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 24.05.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @State private var changeTheme = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Schedule")
            
            Text("Privacy and Security")
            
            Text("Export diary")
            
            Text("Language")
            
            Button("Change Theme") {
                changeTheme.toggle()
            }
            .foregroundStyle(.primary)
//TODO: кнопку пошире
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.highlight, lineWidth: 2)
        )
        .padding(.horizontal)
        .padding(.top, 40)
        .sheet(isPresented: $changeTheme, content: {
            ThemeChanger()
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
    }
}

#Preview {
    SettingsView()
}

