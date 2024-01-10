//
//  ReplaceFasTagRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol ReplaceFasTagRoutingLogic {
  // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ReplaceFasTagDataPassing {
  var dataStore: ReplaceFasTagDataStore? { get }
}

class ReplaceFasTagRouter: NSObject, ReplaceFasTagRoutingLogic, ReplaceFasTagDataPassing {
  weak var viewController: ReplaceFasTagViewController?
  var dataStore: ReplaceFasTagDataStore?
}
