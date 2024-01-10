//
//  SetEmailRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

@objc protocol SetEmailRoutingLogic {
    // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol SetEmailDataPassing {
    var dataStore: SetEmailDataStore? { get }
}

class SetEmailRouter: NSObject, SetEmailRoutingLogic, SetEmailDataPassing {
    weak var viewController: SetEmailViewController?
    var dataStore: SetEmailDataStore?
}
