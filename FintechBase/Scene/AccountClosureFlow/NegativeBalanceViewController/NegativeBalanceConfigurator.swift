//
//  NegativeBalanceConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class NegativeBalanceConfigurator {
    static func configureModule(viewController: NegativeBalanceViewController) {
        let interactor = NegativeBalanceInteractor()
        let worker = NegativeBalanceWorker()
        let presenter = NegativeBalancePresenter()
        let router = NegativeBalanceRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
