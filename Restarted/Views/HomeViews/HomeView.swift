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
                workSection
                habitsSection
                
                Spacer()
            }
            .navigationTitle("Home")
            .background(Color.background)
        }
    }
}

#Preview {
    HomeView()
}

extension HomeView {
    private var workSection: some View {
        VStack {
            Circle()
                .stroke(Color.highlight, lineWidth: 4)
                .padding(40)
            
            RoundedRectangle(cornerRadius: 90)
                .fill(Color.highlight)
                .frame(height: 4)
                .padding(.horizontal)
        }
    }
    
    private var habitsSection: some View {
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
                        .font(.system(size: 24))
                        .foregroundColor(Color.highlight)
                }
            }
        }
        .padding()
    }
}
