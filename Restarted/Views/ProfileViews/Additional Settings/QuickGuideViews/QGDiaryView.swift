//
//  QGDiaryView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.10.2024.
//

import SwiftUI

struct QGDiaryView: View {
    var body: some View {
        VStack {
            Text("Personal Diary")
                .font(.largeTitle)
                .foregroundStyle(Color.highlight)
                .padding(.vertical)
            
            Text("This is a great place to reflect and understand your gaming habits.")
                .font(.title3)
                .padding(.bottom, 70)
        }
    }
}

#Preview {
    QGDiaryView()
}
