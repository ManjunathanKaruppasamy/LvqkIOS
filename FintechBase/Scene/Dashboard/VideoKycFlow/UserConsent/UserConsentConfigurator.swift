//
//  UserConsentConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class UserConsentConfigurator {
    // MARK: Configure the User Consent scene
    static func configureModule(viewController: UserConsentViewController) {
        let interactor = UserConsentInteractor()
        let presenter = UserConsentPresenter()
        let router = UserConsentRouter()
        let worker = UserConsentWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
