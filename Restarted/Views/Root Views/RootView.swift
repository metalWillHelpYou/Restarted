//
//  RootView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 15.11.2024.
//

import SwiftUI

@MainActor
final class RootViewModel: ObservableObject {
    @Published var screen: Screen = .content
    
    func updateAuthenticationState() {
        let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
        DispatchQueue.main.async {
            self.screen = authUser != nil ? .content : .authentication
        }
    }
}

struct RootView: View {
    @EnvironmentObject var root: RootViewModel
    
    var body: some View {
        ZStack {
            if root.screen == .content {
                ContentView()
            } else {
                AuthenticationView()
            }
        }
        .onAppear {
            root.updateAuthenticationState()
        }
    }
}

#Preview {
    RootView()
}
