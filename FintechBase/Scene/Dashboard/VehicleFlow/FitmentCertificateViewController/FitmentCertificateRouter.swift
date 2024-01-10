//
//  FitmentCertificateRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol FitmentCertificateRoutingLogic {
  // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol FitmentCertificateDataPassing {
  var dataStore: FitmentCertificateDataStore? { get }
}

class FitmentCertificateRouter: NSObject, FitmentCertificateRoutingLogic, FitmentCertificateDataPassing {
  weak var viewController: FitmentCertificateViewController?
  var dataStore: FitmentCertificateDataStore?
}
