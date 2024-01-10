//
//  AddVehicleConfigurator.swift
//  FintechBase
//
//  Created by Sravani Madala on 07/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class AddVehicleConfigurator {
    static func configureModule(viewController: AddVehicleViewController) {
       // let apiManager = APIManager()
        let interactor = AddVehicleInteractor()
        let worker = AddVehicleWorker()
        let presenter = AddVehiclePresenter()
        let router = AddVehicleRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
