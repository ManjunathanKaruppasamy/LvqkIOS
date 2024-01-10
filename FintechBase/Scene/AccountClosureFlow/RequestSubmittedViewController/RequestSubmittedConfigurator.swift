//
//  RequestSubmittedConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class RequestSubmittedConfigurator {
    static func configureModule(viewController: RequestSubmittedViewController) {
        let interactor = RequestSubmittedInteractor()
        let worker = RequestSubmittedWorker()
        let presenter = RequestSubmittedPresenter()
        let router = RequestSubmittedRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
