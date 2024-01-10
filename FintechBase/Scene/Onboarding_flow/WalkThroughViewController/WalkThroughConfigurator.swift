//
//  WalkThroughConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class WalkThroughConfigurator {
    /* Configure WalkThrough Scene */
    static func walkThroughConfigureModule(viewController: WalkThroughViewController) {
        let interactor = WalkThroughInteractor()
        let presenter = WalkThroughPresenter()
        let router = WalkThroughRouter()
        let worker = WalkThroughWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
