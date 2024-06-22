//
//  ColorPickerView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 05.06.2024.
//

import SwiftUI

struct ColorPickerView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "lightbulb.fill")
                .resizable()
                .frame(width: 100, height: 160)
                .foregroundStyle(userTheme.setIconColor(with: scheme).gradient)

            Text("Choose a Style")
                .font(.title)
                .foregroundStyle(userTheme.setTextColor(with: scheme))

            CustomPickerView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(userTheme.setBackgroundColor(with: scheme))
        .background(.pickerBG)
        .frame(height: 410)
        .clipShape(.rect(cornerRadius: 15))
        .padding(.horizontal)
        .environment(\.colorScheme, scheme)
    }
}

struct CustomPickerView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @Namespace private var animation
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Theme.allCases, id: \.rawValue) { theme in
                Text(theme.rawValue)
                    .foregroundStyle(.gray).opacity(0.8)
                    .padding(.vertical, 10)
                    .frame(width: 100)
                    .background {
                        ZStack {
                            if userTheme == theme {
                                Capsule()
                                    .fill(.pickerBG)
                                    .matchedGeometryEffect(id: "ACTIVE", in: animation)
                            }
                        }
                        .animation(.snappy, value: userTheme)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        userTheme = theme
                    }
            }
        }
        .padding(3)
        .background(Color.gray.opacity(0.18), in: .capsule)
        .padding(.top)
    }
}

#Preview {
    ColorPickerView()
}
