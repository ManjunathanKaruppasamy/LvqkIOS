//
//  AddMoneyConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class AddMoneyConfigurator {
    
    /* Configure AddMoney Scene */
    static func configureModule(viewController: AddMoneyViewController) {
        let interactor = AddMoneyInteractor()
        let presenter = AddMoneyPresenter()
        let router = AddMoneyRouter()
        let worker = AddMoneyWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
