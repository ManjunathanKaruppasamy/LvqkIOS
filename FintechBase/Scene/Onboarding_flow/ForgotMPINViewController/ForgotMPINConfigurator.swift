//
//  ForgotMPINConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 03/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class ForgotMPINConfigurator {
    /* Configure Forget Mpin scene */
    static func configureModule(viewController: ForgotMPINViewController) {
        let interactor = ForgotMPINInteractor()
        let presenter = ForgotMPINPresenter()
        let router = ForgotMPINRouter()
        let worker = ForgotMPINWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
