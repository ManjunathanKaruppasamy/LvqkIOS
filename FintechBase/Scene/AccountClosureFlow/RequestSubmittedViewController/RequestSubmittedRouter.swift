//
//  RequestSubmittedRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

@objc protocol RequestSubmittedRoutingLogic {
    // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol RequestSubmittedDataPassing {
    var dataStore: RequestSubmittedDataStore? { get }
}

class RequestSubmittedRouter: NSObject, RequestSubmittedRoutingLogic, RequestSubmittedDataPassing {
    weak var viewController: RequestSubmittedViewController?
    var dataStore: RequestSubmittedDataStore?
}
