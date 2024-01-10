//
//  FilterListBottomSheetRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol FilterListBottomSheetRoutingLogic {
  // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol FilterListBottomSheetDataPassing {
  var dataStore: FilterListBottomSheetDataStore? { get }
}

class FilterListBottomSheetRouter: NSObject, FilterListBottomSheetRoutingLogic, FilterListBottomSheetDataPassing {
  weak var viewController: FilterListBottomSheetViewController?
  var dataStore: FilterListBottomSheetDataStore?
}
