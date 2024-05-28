//
//  StatisticView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 27.05.2024.
//

import SwiftUI

struct StatisticView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 40) {
                CirclesView()
                VStack(alignment: .leading, spacing: 24){
                    Text("Habits: 3/3h")
                    
                    Text("Education: 3/3h")
                    
                    Text("Playtime: 2/2h")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.clear)
                .themedStroke()
        )
        .padding(.horizontal)
        .padding(.top)
    }
}

#Preview {
    StatisticView()
}
