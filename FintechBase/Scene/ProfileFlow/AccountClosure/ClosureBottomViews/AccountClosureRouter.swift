//
//  AccountClosureRouter.swift
//  FintechBase
//
//  Created by Sravani Madala on 26/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

@objc protocol AccountClosureRoutingLogic {
    // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AccountClosureDataPassing {
    var dataStore: AccountClosureDataStore? { get }
}

class AccountClosureRouter: NSObject, AccountClosureRoutingLogic, AccountClosureDataPassing {
    weak var viewController: AccountClosureViewController?
    var dataStore: AccountClosureDataStore?
}
