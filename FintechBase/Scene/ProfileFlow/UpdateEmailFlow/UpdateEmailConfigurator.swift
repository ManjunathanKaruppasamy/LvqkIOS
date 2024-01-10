//
//  UpdateEmailConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class UpdateEmailConfigurator {
    // Configure UpdateEmail scene
    static func configureModule(viewController: UpdateEmailViewController) {
        let interactor = UpdateEmailInteractor()
        let presenter = UpdateEmailPresenter()
        let router = UpdateEmailRouter()
        let worker = UpdateEmailWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
