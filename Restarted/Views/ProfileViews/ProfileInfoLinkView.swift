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
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(viewModel.generateGreeting()),")

                    Text(viewModel.localUserName)
                        .foregroundStyle(Color.highlight)
                        .offset(x: -2)
                }
                .padding()
                .font(.title2)
                    
                Text("The most certain way to avoid failure is to commit to success")
                    .padding()
                    .font(.title3)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .padding()
                .foregroundStyle(Color.highlight)
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
