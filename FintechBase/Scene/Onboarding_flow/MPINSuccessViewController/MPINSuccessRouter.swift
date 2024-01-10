//
//  MPINSuccessRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 02/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol MPINSuccessRoutingLogic {
    func routeToTabbarController()
}

protocol MPINSuccessDataPassing {
  var dataStore: MPINSuccessDataStore? { get }
}

class MPINSuccessRouter: NSObject, MPINSuccessRoutingLogic, MPINSuccessDataPassing {
  weak var viewController: MPINSuccessViewController?
  var dataStore: MPINSuccessDataStore?
    
    /* Route To TabbarController */
    func routeToTabbarController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.tabbarViewController) as? TabbarViewController, let sourceVC =  viewController {
            
            TabbarConfigurator.configureModule(viewController: destinationVC)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigation(source: MPINSuccessViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
}
