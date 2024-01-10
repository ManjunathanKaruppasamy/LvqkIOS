//
//  VehicleConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class VehicleConfigurator {
    /* Configure Vehicle Scene */
    static func configureModule(viewController: VehicleViewController) {
        let interactor = VehicleInteractor()
        let presenter = VehiclePresenter()
        let router = VehicleRouter()
        let worker = VehicleWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
