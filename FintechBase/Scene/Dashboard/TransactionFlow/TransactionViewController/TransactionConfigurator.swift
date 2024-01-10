//
//  TransactionConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class TransactionConfigurator {
    static func configureModule(viewController: TransactionViewController) {
        let interactor = TransactionInteractor()
        let presenter = TransactionPresenter()
        let router = TransactionRouter()
        let worker = TransactionWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
