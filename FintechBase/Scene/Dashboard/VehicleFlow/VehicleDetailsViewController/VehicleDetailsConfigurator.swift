//
//  VehicleDetailsConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 15/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class VehicleDetailsConfigurator {
    /* Configure Vehicle Details scene */
    static func configureModule(viewController: VehicleDetailsViewController) {
        let interactor = VehicleDetailsInteractor()
        let presenter = VehicleDetailsPresenter()
        let router = VehicleDetailsRouter()
        let worker = VehicleDetailsWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
