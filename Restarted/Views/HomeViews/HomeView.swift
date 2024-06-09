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
                    .stroke(Color.highlight, lineWidth: 4)
                    .padding(40)
                
                RoundedRectangle(cornerRadius: 90)
                    .fill(Color.highlight)
                    .frame(height: 4)
                    .padding(.horizontal)
                
                HStack {
                    Text("Habits:")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    NavigationLink(destination: HabitListView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.highlight, lineWidth: 2)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "plus")
                                .foregroundColor(Color.highlight)
                                .font(.system(size: 24))
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Home")
            .background(Color.background)
        }
        .preferredColorScheme(userTheme.setTheme)
    }
}

#Preview {
    HomeView()
}
