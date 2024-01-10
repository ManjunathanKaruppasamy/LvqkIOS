//
//  CustomerSupportRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 06/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol CustomerSupportRoutingLogic {

}

protocol CustomerSupportDataPassing {
  var dataStore: CustomerSupportDataStore? { get }
}

class CustomerSupportRouter: NSObject, CustomerSupportRoutingLogic, CustomerSupportDataPassing {
  weak var viewController: CustomerSupportViewController?
  var dataStore: CustomerSupportDataStore?
}
