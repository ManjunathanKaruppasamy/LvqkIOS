//
//  AadhaarVerificationConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/11/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class AadhaarVerificationConfigurator {
    static func configureModule(viewController: AadhaarVerificationViewController) {
//        let apiManager = APIManager()
        let interactor = AadhaarVerificationInteractor()
        let worker = AadhaarVerificationWorker()
        let presenter = AadhaarVerificationPresenter()
        let router = AadhaarVerificationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
