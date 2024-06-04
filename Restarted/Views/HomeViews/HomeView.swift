//
//  HomeView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        NavigationStack{
            VStack {
                Circle()
                    .padding(48)
                
                RoundedRectangle(cornerRadius: 90)
                    .frame(height: 4)
                    .padding(.horizontal)
                
                HStack {
                    Text("Habits:")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    NavigationLink(destination: HabitList()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 2)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "plus")
                                .foregroundColor(Color.green)
                                .font(.system(size: 24, weight: .bold))
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Home")
            .background(Color.background)
        }
        .preferredColorScheme(userTheme.colorTheme)
    }
}

#Preview {
    HomeView()
}
