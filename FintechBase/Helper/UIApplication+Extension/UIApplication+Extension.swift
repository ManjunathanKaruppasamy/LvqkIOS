//
//  UIApplication+Extension.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 14/06/22.
//

import Foundation
import UIKit

/* UIApplication Extension */
extension UIApplication {

    /* Get the Top VC */
    class func getTopViewController(base: UIViewController? =
                                    UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
