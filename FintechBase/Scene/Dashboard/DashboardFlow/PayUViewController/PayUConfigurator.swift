//
//  PayUConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 24/04/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class PayUConfigurator {
    /* Configure PayU scene */
    static func configureModule(viewController: PayUViewController) {
        let interactor = PayUInteractor()
        let presenter = PayUPresenter()
        let router = PayURouter()
        let worker = PayUWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
