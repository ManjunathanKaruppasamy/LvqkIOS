//
//  Theme.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//

import Foundation
import UIKit

@propertyWrapper
struct Theme {
    let light: UIColor
    let dark: UIColor

    var wrappedValue: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return self.dark
                } else {
                    return self.light
                }
            }
        } else {
            return ThemeManager.isDarkModeEnabled ? self.dark : self.light
        }
    }
}

enum ThemeManager {
    static var isDarkModeEnabled = false
}
