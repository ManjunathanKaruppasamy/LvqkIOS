//
//  ReasonsForClosureConfigurator.swift
//  FintechBase
//
//  Created by Sravani Madala on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class ReasonsForClosureConfigurator {
    static func configureModule(viewController: ReasonsForClosureViewController) {
       // let apiManager = APIManager()
        let interactor = ReasonsForClosureInteractor()
        let worker = ReasonsForClosureWorker()
        let presenter = ReasonsForClosurePresenter()
        let router = ReasonsForClosureRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
