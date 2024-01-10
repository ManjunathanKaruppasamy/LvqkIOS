//
//  ProfileRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol ProfileRoutingLogic {
  // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ProfileDataPassing {
  var dataStore: ProfileDataStore? { get }
}

class ProfileRouter: NSObject, ProfileRoutingLogic, ProfileDataPassing {
  weak var viewController: ProfileViewController?
  var dataStore: ProfileDataStore?
}
