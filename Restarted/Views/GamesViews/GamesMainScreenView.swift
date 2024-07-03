//
//  GamesMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.05.2024.
//

import SwiftUI

struct GamesMainScreenView: View {
    @State private var isSetTimePresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                
            }
            .navigationTitle("Games")
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .navigationDestination(isPresented: $isSetTimePresented, destination: {
                SetGameTimerView()
            })
        }
    }
}

#Preview {
    GamesMainScreenView()
}
