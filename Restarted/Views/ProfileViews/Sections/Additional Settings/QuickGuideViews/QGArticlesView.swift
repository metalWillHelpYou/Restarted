//
//  QGArticlesView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 10.10.2024.
//

import SwiftUI

struct QGArticlesView: View {
    @State private var shouldAnimate = false
    @State private var isArticlechanged = false
    
    var body: some View {
        VStack {
            Text("Articles")
                .font(.largeTitle)
                .foregroundStyle(Color.highlight)
                .padding(.vertical)
            
            Text("Read tips to better understand the problem and find ways to overcome it.")
                .font(.title3)
                .padding(.bottom, 70)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(isArticlechanged ? Color.green.opacity(0.3) : Color.clear)
                    .frame(height: 72)
                    .strokeBackground()
                
                HStack {
                    Text("The first steps to understanding the problem")
                        .foregroundColor(Color.text)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    Image(systemName: isArticlechanged ? "checkmark.circle" : "circle")
                        .foregroundColor(.highlight)
                }
                .padding(.trailing)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .animation(shouldAnimate ? .easeInOut(duration: 0.5) : nil, value: isArticlechanged)
            .onAppear {
                shouldAnimate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isArticlechanged = true
                }
            }
            .onDisappear {
                shouldAnimate = false
                isArticlechanged = false
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.clear)
                    .frame(height: 72)
                    .strokeBackground()
                
                HStack {
                    Text("How to recognize the signs of videogame addiction?")
                        .foregroundColor(Color.text)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    Image(systemName: "circle")
                        .foregroundColor(.highlight)
                }
                .padding(.trailing)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .padding()
    }
}

#Preview {
    QGArticlesView()
}
