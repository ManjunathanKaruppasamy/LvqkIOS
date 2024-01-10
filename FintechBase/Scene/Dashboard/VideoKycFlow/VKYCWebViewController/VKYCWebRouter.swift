//
//  VKYCWebRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 02/05/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol VKYCWebRoutingLogic {
  func routeToDashboard()
}

protocol VKYCWebDataPassing {
  var dataStore: VKYCWebDataStore? { get }
}

class VKYCWebRouter: NSObject, VKYCWebRoutingLogic, VKYCWebDataPassing {
  weak var viewController: VKYCWebViewController?
  var dataStore: VKYCWebDataStore?
    
    // MARK: Route to Dashboard
    func routeToDashboard() {
        self.viewController?.dismiss(animated: false, completion: {
            if let topVC = UIApplication.getTopViewController() {
                topVC.popToViewController(destination: TabbarViewController.self)
            }
        })
    }
}
