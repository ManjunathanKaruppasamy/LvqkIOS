//
//  BankAccountDetailsConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class BankAccountDetailsConfigurator {
    static func configureModule(viewController: BankAccountDetailsViewController) {
//        let apiManager = APIManager()
        let interactor = BankAccountDetailsInteractor()
        let worker = BankAccountDetailsWorker()
        let presenter = BankAccountDetailsPresenter()
        let router = BankAccountDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
