//
//  AccountDetailsConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class AccountDetailsConfigurator {
    /* Configure Account Details Scene */
    static func configureModule(viewController: AccountDetailsViewController) {
        let interactor = AccountDetailsInteractor()
        let presenter = AccountDetailsPresenter()
        let router = AccountDetailsRouter()
        let worker = AccountDetailsWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
