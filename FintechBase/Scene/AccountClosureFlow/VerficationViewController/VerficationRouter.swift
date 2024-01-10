//
//  VerficationRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol VerficationRoutingLogic {
    // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol VerficationDataPassing {
    var dataStore: VerficationDataStore? { get }
}

class VerficationRouter: NSObject, VerficationRoutingLogic, VerficationDataPassing {
    weak var viewController: VerficationViewController?
    var dataStore: VerficationDataStore?
}
