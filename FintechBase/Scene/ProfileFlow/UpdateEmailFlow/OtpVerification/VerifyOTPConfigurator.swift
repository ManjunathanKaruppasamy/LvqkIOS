//
//  VerifyOTPConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class VerifyOTPConfigurator {
    // MARK: Configure Verify OTP scene
    static func configureModule(viewController: VerifyOTPViewController) {
        let interactor = VerifyOTPInteractor()
        let presenter = VerifyOTPPresenter()
        let router = VerifyOTPRouter()
        let worker = VerifyOTPWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
