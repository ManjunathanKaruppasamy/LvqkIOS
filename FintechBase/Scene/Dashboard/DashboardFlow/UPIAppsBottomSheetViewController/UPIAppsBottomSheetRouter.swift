//
//  UPIAppsBottomSheetRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/06/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol UPIAppsBottomSheetRoutingLogic {
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol UPIAppsBottomSheetDataPassing {
  var dataStore: UPIAppsBottomSheetDataStore? { get }
}

class UPIAppsBottomSheetRouter: NSObject, UPIAppsBottomSheetRoutingLogic, UPIAppsBottomSheetDataPassing {
  weak var viewController: UPIAppsBottomSheetViewController?
  var dataStore: UPIAppsBottomSheetDataStore?
}
