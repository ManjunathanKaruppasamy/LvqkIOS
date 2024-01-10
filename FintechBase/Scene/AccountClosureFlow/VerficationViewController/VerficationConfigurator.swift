//
//  VerficationConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class VerficationConfigurator {
    static func configureModule(viewController: VerficationViewController) {
        let interactor = VerficationInteractor()
        let worker = VerficationWorker()
        let presenter = VerficationPresenter()
        let router = VerficationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
