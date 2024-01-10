//
//  PaymentMethodConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 13/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class PaymentMethodConfigurator {
    /* Configure Payment Method */
    static func configureModule(viewController: PaymentMethodViewController) {
        let interactor = PaymentMethodInteractor()
        let presenter = PaymentMethodPresenter()
        let router = PaymentMethodRouter()
        let worker = PaymentMethodWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
