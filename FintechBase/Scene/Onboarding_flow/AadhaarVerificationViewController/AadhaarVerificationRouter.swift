//
//  AadhaarVerificationRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/11/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

@objc protocol AadhaarVerificationRoutingLogic {
    // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AadhaarVerificationDataPassing {
    var dataStore: AadhaarVerificationDataStore? { get }
}

class AadhaarVerificationRouter: NSObject, AadhaarVerificationRoutingLogic, AadhaarVerificationDataPassing {
    weak var viewController: AadhaarVerificationViewController?
    var dataStore: AadhaarVerificationDataStore?
}
