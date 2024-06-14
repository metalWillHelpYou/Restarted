//
//  LanguageView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 14.06.2024.
//

import SwiftUI

struct LanguageView: View {
    var body: some View {
        VStack {
            VStack(spacing: 16){
                Button(action: {
                    
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("English")
                        Text("English")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
                }
                
                Button(action: {
                    
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Russian")
                        Text("Русский")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
                }
                
                Button(action: {
                    
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Czech")
                        Text("Čeština")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .strokeBacground()
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    LanguageView()
}
