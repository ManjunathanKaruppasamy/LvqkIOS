//
//  VerifyAccountRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol VerifyAccountRoutingLogic {
  // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol VerifyAccountDataPassing {
  var dataStore: VerifyAccountDataStore? { get }
}

class VerifyAccountRouter: NSObject, VerifyAccountRoutingLogic, VerifyAccountDataPassing {
  weak var viewController: VerifyAccountViewController?
  var dataStore: VerifyAccountDataStore?
}
