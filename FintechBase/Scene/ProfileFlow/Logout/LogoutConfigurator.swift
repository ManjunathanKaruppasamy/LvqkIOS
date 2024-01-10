//
//  LogoutConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 20/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class LogoutConfigurator {
    // MARK: Configure the Logout Scene
    static func configureModule(viewController: LogoutViewController) {
        let interactor = LogoutInteractor()
        let presenter = LogoutPresenter()
        let router = LogoutRouter()
        let worker = LogoutWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
