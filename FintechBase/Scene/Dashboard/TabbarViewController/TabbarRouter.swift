//
//  TabbarRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol TabbarRoutingLogic {
  // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol TabbarDataPassing {
  var dataStore: TabbarDataStore? { get }
}

class TabbarRouter: NSObject, TabbarRoutingLogic, TabbarDataPassing {
  weak var viewController: TabbarViewController?
  var dataStore: TabbarDataStore?
}
