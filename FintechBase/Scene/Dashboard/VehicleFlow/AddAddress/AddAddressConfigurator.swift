//
//  AddAddressConfigurator.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class AddAddressConfigurator {
    static func configureModule(viewController: AddAddressViewController) {
        let interactor = AddAddressInteractor()
        let worker = AddAddressWorker()
        let presenter = AddAddressPresenter()
        let router = AddAddressRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
