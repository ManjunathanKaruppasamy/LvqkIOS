//
//  CommonMpinConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class CommonMpinConfigurator {
    /* Configure the CommonMpin */
    static func configureModule(viewController: CommonMpinViewController) {
        let interactor = CommonMpinInteractor()
        let presenter = CommonMpinPresenter()
        let router = CommonMpinRouter()
        let worker = CommonMpinWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
