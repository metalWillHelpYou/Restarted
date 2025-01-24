//
//  LanguageManager.swift
//  Restarted
//
//  Created by metalWillHelpYou on 24.01.2025.
//

import Foundation

final class LanguageManager: ObservableObject {
    @Published var locale: Locale
    
    init() {
        let savedCode = UserDefaults.standard.string(forKey: "AppLanguageCode")
        
        if let code = savedCode {
            self.locale = Locale(identifier: code)
        } else {
            self.locale = Locale.current
        }
    }
    
    func updateLanguage(to code: String) {
        UserDefaults.standard.set(code, forKey: "AppLanguageCode")
        
        self.locale = Locale(identifier: code)
    }
}
