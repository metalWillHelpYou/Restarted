//
//  RemindersSetupView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 09.06.2024.
//

import SwiftUI

struct RemindersSetupView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reminders")
                .font(.title2).bold()
            
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 40)
                    .foregroundStyle(Color.highlight)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 40)
                    .foregroundStyle(Color.highlight)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    RemindersSetupView()
}
