//
//  AddAddressRouter.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

@objc protocol AddAddressRoutingLogic {
    // func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AddAddressDataPassing {
    var dataStore: AddAddressDataStore? { get }
}

class AddAddressRouter: NSObject, AddAddressRoutingLogic, AddAddressDataPassing {
    weak var viewController: AddAddressViewController?
    var dataStore: AddAddressDataStore?
}
