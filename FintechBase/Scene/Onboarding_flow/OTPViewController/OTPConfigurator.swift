//
//  OTPConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class OTPConfigurator {
    /* Configure OTPView Scene */
    static func otpConfigureModule(viewController: OTPViewController) {
        let interactor = OTPInteractor()
        let presenter = OTPPresenter()
        let router = OTPRouter()
        let worker = OtpWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
