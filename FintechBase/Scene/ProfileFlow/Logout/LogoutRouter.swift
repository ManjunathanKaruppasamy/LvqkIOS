//
//  LogoutRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 20/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol LogoutRoutingLogic {
    func routeToInitialUserFlow() 
}

protocol LogoutDataPassing {
  var dataStore: LogoutDataStore? { get }
}

class LogoutRouter: NSObject, LogoutRoutingLogic, LogoutDataPassing {
    weak var viewController: LogoutViewController?
    var dataStore: LogoutDataStore?
    
    /* Route To InitialUserFlow */
    func routeToInitialUserFlow() {
        self.viewController?.dismiss(animated: false, completion: {
            if let topViewController = UIApplication.getTopViewController() {
                    topViewController.navigationController?.popToRootViewController(animated: false)
            }
        })
    }
}
