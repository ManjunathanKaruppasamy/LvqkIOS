//
//  UserConsentRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol UserConsentRoutingLogic {
  // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol UserConsentDataPassing {
  var dataStore: UserConsentDataStore? { get }
}

class UserConsentRouter: NSObject, UserConsentRoutingLogic, UserConsentDataPassing {
  weak var viewController: UserConsentViewController?
  var dataStore: UserConsentDataStore?
}
