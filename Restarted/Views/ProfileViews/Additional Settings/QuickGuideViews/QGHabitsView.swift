//
//  QGHabitsView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.10.2024.
//

import SwiftUI

struct QGHabitsView: View {
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("Practice Tracker")
                .font(.largeTitle)
                .foregroundStyle(Color.highlight)
                .padding(.vertical)
            
            Text("Set goals and track their time.")
                .font(.title3)
                .padding(.bottom, 70)
            
            List {
                Text("Cycling")
                    .listRowBackground(Color.background)
                    .listRowSeparatorTint(Color.highlight)
                
                Text("Reading")
                    .listRowBackground(Color.background)
                    .listRowSeparatorTint(Color.highlight)
                
                Text("Learning Russian")
                    .listRowBackground(Color.background)
                    .listRowSeparatorTint(Color.highlight)
            }
            .frame(maxHeight: 150)
            .listStyle(.plain)
            .scrollDisabled(true)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    QGHabitsView()
}
