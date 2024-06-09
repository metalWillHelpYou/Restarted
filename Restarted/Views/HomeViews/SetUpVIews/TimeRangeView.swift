//
//  TimeRangeView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.06.2024.
//

import SwiftUI

struct TimeRangeView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Time Range")
                .font(.title2).bold()
            
            HStack(spacing: 12) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 100, height: 40)
                        .foregroundStyle(Color.highlight)
                }
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    TimeRangeView()
}
