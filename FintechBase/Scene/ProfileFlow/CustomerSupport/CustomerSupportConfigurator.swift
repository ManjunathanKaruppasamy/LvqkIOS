//
//  CustomerSupportConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 06/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class CustomerSupportConfigurator {
    // MARK: Configure CustomerSupport scene
    static func configureModule(viewController: CustomerSupportViewController) {
        let interactor = CustomerSupportInteractor()
        let presenter = CustomerSupportPresenter()
        let router = CustomerSupportRouter()
        let worker = CustomerSupportWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
