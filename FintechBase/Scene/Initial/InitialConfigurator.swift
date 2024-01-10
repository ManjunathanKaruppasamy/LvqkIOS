//
//  InitialConfigurator.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 10/07/22.
//

import Foundation
import UIKit

class InitialConfigurator {
    /* Configure The InitialView Scene */
    static func configureModule(viewController: InitialViewController) {
        let interactor = InitialInteractor()
        let presenter = InitialPresenter()
        let router = InitialRouter()
        let worker = InitialWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        router.navigationController = viewController.navigationController
    }
}
