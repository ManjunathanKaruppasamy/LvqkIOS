//
//  MobileNumberConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class MobileNumberConfigurator {
    /* Configure MobileNumber Scene */
    static func mobileNumberConfigureModule(viewController: MobileNumberViewController) {
        let interactor = MobileNumberInteractor()
        let presenter = MobileNumberPresenter()
        let router = MobileNumberRouter()
        let worker = MobileNumberWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
