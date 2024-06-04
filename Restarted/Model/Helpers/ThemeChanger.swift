//
//  ThemeChanger.swift
//  Restarted
//
//  Created by metalWillHelpYou on 04.06.2024.
//

import SwiftUI

struct ThemeChanger: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "lightbulb.fill")
                .resizable()
                .frame(width: 100, height: 160)
                .foregroundStyle(userTheme.iconColor(scheme).gradient)
            
            Text("Choose a Style")
                .font(.title).bold()
            
            CustomPickerView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color.white)
        .frame(height: 410)
        .background(.pickerBG)
        .clipShape(.rect(cornerRadius: 30))
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
        .background(Color.primary.opacity(0.06), in: .capsule)
        .padding(.top, 20)
    }
}
//TODO: переключатель для background
enum Theme: String, CaseIterable {
    case systemDefault = "Default"
    case light = "Light"
    case dark = "Dark"
    
    func iconColor(_ scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault:
            return Color(.systemMint)
        case .light:
            return .lightIcon
        case .dark:
            return Color(.tertiarySystemFill)
        }
    }
    
//    func icon(_ scheme: ColorScheme) -> String {
//        switch self {
//        case .systemDefault, .light:
//            return "lightbulb.fill"
//        case .dark:
//            return "lightbulb"
//        }
//    }
    
    var colorTheme: ColorScheme? {
        switch self {
        case .systemDefault:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

#Preview {
    ThemeChanger()
}
