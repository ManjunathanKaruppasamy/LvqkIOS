//
//  SettingsConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class SettingsConfigurator {
    // MARK: Configure Settings scene
    static func configureModule(viewController: SettingsViewController) {
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        let worker = SettingsWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
