//
//  LanguageView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 14.06.2024.
//

import SwiftUI

struct LanguageView: View {
    @EnvironmentObject var languageSettings: LanguageManager
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        languageSettings.updateLanguage(to: "en")
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("English")
                            Text("English")
                                .font(.caption)
                        }
                        Spacer()
                        if languageSettings.locale.identifier == "en" {
                            Image(systemName: "checkmark")
                                .transition(.scale)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
                }
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        languageSettings.updateLanguage(to: "ru")
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Russian")
                            Text("Русский")
                                .font(.caption)
                        }
                        Spacer()
                        if languageSettings.locale.identifier == "ru" {
                            Image(systemName: "checkmark")
                                .transition(.scale)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
                }
    
                Button(action: {
                    withAnimation(.easeInOut) {
                        languageSettings.updateLanguage(to: "cs")
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Czech")
                            Text("Čeština")
                                .font(.caption)
                        }
                        Spacer()
                        if languageSettings.locale.identifier == "cs" {
                            Image(systemName: "checkmark")
                                .transition(.scale)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .strokeBackground(Color.highlight)
            .padding()
            .animation(.default, value: languageSettings.locale.identifier)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    LanguageView()
        .environmentObject(LanguageManager())
}
