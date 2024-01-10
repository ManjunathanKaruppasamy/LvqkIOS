//
//  GenericWebRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 17/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol GenericWebRoutingLogic {
  
}

protocol GenericWebDataPassing {
  var dataStore: GenericWebDataStore? { get }
}

class GenericWebRouter: NSObject, GenericWebRoutingLogic, GenericWebDataPassing {
  weak var viewController: GenericWebViewController?
  var dataStore: GenericWebDataStore?
}
