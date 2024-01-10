//
//  TabbarConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class TabbarConfigurator {
    /* Configure TabBar Scene */
    static func configureModule(viewController: TabbarViewController) {
        let interactor = TabbarInteractor()
        let presenter = TabbarPresenter()
        let router = TabbarRouter()
        let worker = TabbarWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
