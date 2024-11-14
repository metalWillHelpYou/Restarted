//
//  SettingsView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 24.05.2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showApperance = false
    @State private var showLanguage = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Schedule")
            
            Text("Privacy and Security")
            
            Toggle(isOn: $viewModel.isNotificationsOn) {
                Text("Notifications")
            }
            .toggleStyle(SwitchToggleStyle(tint: Color.highlight))
            .onChange(of: viewModel.isNotificationsOn) {
                viewModel.toggleNotifications()
            }
            
            NavigationLink(destination: LanguageView()) {
                Text("Language")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
            }
            
            Button(action: {
                showApperance.toggle()
            }) {
                Text("Appearance")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .strokeBackground(Color.highlight)
        .padding(.horizontal)
        //.padding(.top, 40)
        .sheet(isPresented: $showApperance, content: {
            ColorPickerView()
                .presentationDetents([.height(410)])
                .presentationDragIndicator(.visible)
                .presentationBackground(.clear)
        })
    }
}

#Preview {
    SettingsView(viewModel: ProfileViewModel())
}
