//
//  SetEmailConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class SetEmailConfigurator {
    static func configureModule(viewController: SetEmailViewController) {
        let interactor = SetEmailInteractor()
        let worker = SetEmailWorker()
        let presenter = SetEmailPresenter()
        let router = SetEmailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
