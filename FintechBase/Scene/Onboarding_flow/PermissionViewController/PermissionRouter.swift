//
//  PermissionRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol PermissionRoutingLogic {
  func routeToMobileNumber()
}

protocol PermissionDataPassing {
  var dataStore: PermissionDataStore? { get }
}

class PermissionRouter: NSObject, PermissionRoutingLogic, PermissionDataPassing {
  weak var viewController: PermissionViewController?
  var dataStore: PermissionDataStore?
    
    /* Route To MobileNumberVC */
    func routeToMobileNumber() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.mobileNumberViewController) as? MobileNumberViewController, let sourceVC =  viewController {
            MobileNumberConfigurator.mobileNumberConfigureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigation(source: PermissionViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
}
