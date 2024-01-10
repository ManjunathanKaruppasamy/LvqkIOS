//
//  VerifyAadharConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class VerifyAadharConfigurator {
    // MARK: Configure Verify Aadhar scene
    static func configureModule(viewController: VerifyAadharViewController) {
        let interactor = VerifyAadharInteractor()
        let presenter = VerifyAadharPresenter()
        let router = VerifyAadharRouter()
        let worker = VerifyAadharWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
