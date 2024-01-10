//
//  PayURouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 24/04/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol PayURoutingLogic {
    func routeToDashboard()
    func routeToAddMoney()
}

protocol PayUDataPassing {
  var dataStore: PayUDataStore? { get }
}

class PayURouter: NSObject, PayURoutingLogic, PayUDataPassing {
  weak var viewController: PayUViewController?
  var dataStore: PayUDataStore?

    // MARK: Route to Dashboard
    func routeToDashboard() {
        self.viewController?.dismiss(animated: false, completion: {
            if let topVC = UIApplication.getTopViewController() {
                topVC.popToViewController(destination: TabbarViewController.self)
            }
        })
    }
    
    // MARK: Route to AddMoney
    func routeToAddMoney() {
        self.viewController?.dismissVC()
    }
}
