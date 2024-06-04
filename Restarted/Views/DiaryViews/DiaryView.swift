//
//  DiaryView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct DiaryView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 15)
                    .padding()
                    .foregroundStyle(Color("DiaryPaper"))
                
                
                Text("How do you feel?")
                    .font(.body)
                    .fontWeight(.bold)
                    .padding([.top, .leading], 40)
            }
            .navigationTitle("Diary")
            .background(Color.background)
        }
        .preferredColorScheme(userTheme.colorTheme)
    }
}

#Preview {
    DiaryView()
}
