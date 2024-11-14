//
//  Utilites.swift
//  Restarted
//
//  Created by metalWillHelpYou on 14.11.2024.
//

import Foundation
import UIKit

final class Utilites {
    static let shared = Utilites()
    private init() { }
    
    func topViewController(controller: UIViewController? = UIApplication.shared
                                .connectedScenes
                                .compactMap { $0 as? UIWindowScene }
                                .flatMap { $0.windows }
                                .first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

}
