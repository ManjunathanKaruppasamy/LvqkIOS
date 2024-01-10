//
//  WalkThroughRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol WalkThroughRoutingLogic {
    func routeToMobileNumber()
    func routeToPermissionViewController()
}

protocol WalkThroughDataPassing {
  var dataStore: WalkThroughDataStore? { get }
}

class WalkThroughRouter: NSObject, WalkThroughRoutingLogic, WalkThroughDataPassing {
  weak var viewController: WalkThroughViewController?
  var dataStore: WalkThroughDataStore?
    
    /* Route To PermissionViewController */
    func routeToPermissionViewController() {
        let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard, bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.permissionViewController) as? PermissionViewController

        if let destinationVC = destinationVC, let sourceVC =  viewController {
            PermissionConfigurator.permissionConfigureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC)
        }
        
    }
    /* Route To MobileNumberVC */
    func routeToMobileNumber() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.mobileNumberViewController) as? MobileNumberViewController, let sourceVC =  viewController {
            MobileNumberConfigurator.mobileNumberConfigureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    private func navigation(source: WalkThroughViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: false)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    // MARK: Passing data
    private func passDataToPermissionVc(source: WalkThroughDataStore?, destination: inout PermissionDataStore?) {
    }
}
