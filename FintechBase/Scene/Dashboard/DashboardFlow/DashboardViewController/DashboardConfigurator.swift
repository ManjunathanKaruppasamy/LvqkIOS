//
//  DashboardConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 08/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class DashboardConfigurator {
    /* Configure DashBaord Scene */
    static func configureModule(viewController: DashboardViewController) {
        let interactor = DashboardInteractor()
        let presenter = DashboardPresenter()
        let router = DashboardRouter()
        let worker = DashboardWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
