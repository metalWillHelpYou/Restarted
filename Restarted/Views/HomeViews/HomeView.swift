//
//  HomeView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            VStack {
                Text("Welcome!")
            }
            .navigationTitle("Your productivity")
            .themedModifiers()
        }
    }
}

#Preview {
    HomeView()
}
