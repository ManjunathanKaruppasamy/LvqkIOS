//
//  TransactionDetailsConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 21/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class TransactionDetailsConfigurator {
    static func configureModule(viewController: TransactionDetailsViewController) {
        let interactor = TransactionDetailsInteractor()
        let presenter = TransactionDetailsPresenter()
        let router = TransactionDetailsRouter()
        let worker = TransactionDetailsWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
