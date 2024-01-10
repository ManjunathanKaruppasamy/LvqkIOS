//
//  MPINSuccessConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 02/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class MPINSuccessConfigurator {
    /* Configure MpinSuccess scene */
    static func configureModule(viewController: MPINSuccessViewController) {
        let interactor = MPINSuccessInteractor()
        let presenter = MPINSuccessPresenter()
        let router = MPINSuccessRouter()
        let worker = MPINSuccessWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
