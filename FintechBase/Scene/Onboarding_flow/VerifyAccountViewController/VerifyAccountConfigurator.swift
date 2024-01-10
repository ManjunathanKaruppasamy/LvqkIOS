//
//  VerifyAccountConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class VerifyAccountConfigurator {
    /* Configure Verify Account scene */
    static func configureModule(viewController: VerifyAccountViewController) {
        let interactor = VerifyAccountInteractor()
        let presenter = VerifyAccountPresenter()
        let router = VerifyAccountRouter()
        let worker = VerifyAccountWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
