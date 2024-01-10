//
//  AccountClosureConfigurator.swift
//  FintechBase
//
//  Created by Sravani Madala on 26/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class AccountClosureConfigurator {
    static func configureModule(viewController: AccountClosureViewController) {
    //    let apiManager = APIManager()
        let interactor = AccountClosureInteractor()
        let worker = AccountClosureWorker()
        let presenter = AccountClosurePresenter()
        let router = AccountClosureRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
