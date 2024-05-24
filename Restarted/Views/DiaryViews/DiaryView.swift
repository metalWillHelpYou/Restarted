//
//  DiaryView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct DiaryView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 15)
                    .padding()
                    .foregroundStyle(Color("DiaryPaper"))

                
                Text("Write about it...")
                    .font(.body)
                    .fontWeight(.bold)
                    .padding([.top, .leading], 40)
            }
            .navigationTitle("How do you feel?")
            .themedModifiers()
        }
    }
}

#Preview {
    DiaryView()
}
