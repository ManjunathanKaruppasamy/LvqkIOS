//
//  VehicleDocumentConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class VehicleDocumentConfigurator {
    static func configureModule(viewController: VehicleDocumentViewController) {
//        let apiManager = APIManager()
        let interactor = VehicleDocumentInteractor()
        let worker = VehicleDocumentWorker()
        let presenter = VehicleDocumentPresenter()
        let router = VehicleDocumentRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
