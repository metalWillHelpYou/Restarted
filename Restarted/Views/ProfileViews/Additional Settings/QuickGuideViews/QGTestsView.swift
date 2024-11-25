//
//  QGTestsView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.10.2024.
//

import SwiftUI

struct QGTestsView: View {
    @State private var answer: String = "Do you play games?"
    
    var body: some View {
        VStack {
            Text("Psychological tests")
                .font(.largeTitle)
                .foregroundStyle(Color.highlight)
                .padding(.vertical)
            
            Text("Use IQ-20 and IGDS9-SF tests, they will help in diagnosis of gaming addiction.")
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.bottom, 70)
            
            VStack {
                Text(answer)
                    .font(.title2)
                
                VStack(spacing: 16) {
                    Button(action: {
                        answer = "Me too!"
                    }) {
                        Text("Yes")
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.text)
                            .strokeBackground(Color.highlight)
                    }
                    
                    Button(action: {
                        answer = "I don't believe you"
                    }) {
                        Text("No")
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.text)
                            .strokeBackground(Color.highlight)
                    }
                }
            }
        }
        .onDisappear {
            answer = "Do you play games?"
        }
        .padding()
    }
}

#Preview {
    QGTestsView()
}
