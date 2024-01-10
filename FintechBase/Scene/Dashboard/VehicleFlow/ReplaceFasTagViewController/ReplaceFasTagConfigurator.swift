//
//  ReplaceFasTagConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class ReplaceFasTagConfigurator {
    /* Configure ReplaceFasTag Scene */
    static func configureModule(viewController: ReplaceFasTagViewController) {
        let interactor = ReplaceFasTagInteractor()
        let presenter = ReplaceFasTagPresenter()
        let router = ReplaceFasTagRouter()
        let worker = ReplaceFasTagWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
