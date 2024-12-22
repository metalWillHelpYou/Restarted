//
//  ProfileInfoLinkView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.12.2024.
//

import SwiftUI

struct ProfileInfoLinkView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.generateGreeting()), \(viewModel.localUserName)")
                .padding()
                .font(.title2)
                
            Text("Волк это не волк волк это ходить")
                .padding()
                .font(.title2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(Color.primary)
        .strokeBackground(Color.highlight)
        .padding(.horizontal)
    }
}

#Preview {
    ProfileInfoLinkView()
        .environmentObject(ProfileViewModel())
}
