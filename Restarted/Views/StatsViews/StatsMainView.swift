//
//  StatsMainView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI
import MarkdownUI

struct StatsMainView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                StatisticView()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Stats")
            .background(Color.background)
        }
    }
}

#Preview {
    StatsMainView()
}
