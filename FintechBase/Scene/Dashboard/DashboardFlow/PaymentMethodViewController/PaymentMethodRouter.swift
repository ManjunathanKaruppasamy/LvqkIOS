//
//  PaymentMethodRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 13/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol PaymentMethodRoutingLogic {
  // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol PaymentMethodDataPassing {
  var dataStore: PaymentMethodDataStore? { get }
}

class PaymentMethodRouter: NSObject, PaymentMethodRoutingLogic, PaymentMethodDataPassing {
  weak var viewController: PaymentMethodViewController?
  var dataStore: PaymentMethodDataStore?
}
