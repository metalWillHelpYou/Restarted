//
//  TimerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 11.06.2024.
//

import SwiftUI

struct TimerView: View {
    var body: some View {
        VStack {
            Text("Enjoy Your Game")
                .foregroundStyle(.white)
                .font(.largeTitle)

            
            Text("O2 : 49")
                .foregroundStyle(.white)
                .font(.system(size: 60))
                .padding(.vertical, 64)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

#Preview {
    TimerView()
}
