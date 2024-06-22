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
            ZStack(alignment: .topLeading){
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.diaryPaper)
                    .padding()
                    .padding(.bottom)
                
                Text("How do you feel?")
                    .foregroundColor(Color.primary)
                    .font(.body)
                    .padding([.top, .leading], 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Diary")
            .background(Color.background)
        }
        .preferredColorScheme(userTheme.setTheme)
    }
}

#Preview {
    DiaryView()
}
