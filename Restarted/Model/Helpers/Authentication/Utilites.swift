//
//  Utilites.swift
//  Restarted
//
//  Created by metalWillHelpYou on 14.11.2024.
//

import Foundation
import UIKit

// Shared app‑wide helper functions
final class Utilites {
    // Global singleton instance
    static let shared = Utilites()
    private init() { }
    
    // Returns the topmost visible view controller in the current window
    func topViewController(controller: UIViewController? = UIApplication.shared
                                .connectedScenes
                                .compactMap { $0 as? UIWindowScene }
                                .flatMap { $0.windows }
                                .first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        // Unwrap navigation controller branch
        if let nav = controller as? UINavigationController {
            return topViewController(controller: nav.visibleViewController)
        }
        // Unwrap tab bar controller branch
        if let tab = controller as? UITabBarController,
           let selected = tab.selectedViewController {
            return topViewController(controller: selected)
        }
        // Follow any presented view controllers
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        // Base case of recursion
        return controller
    }
}
