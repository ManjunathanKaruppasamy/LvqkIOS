//
//  FastTagDetailsConfigurator.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class FastTagDetailsConfigurator {
    static func configureModule(viewController: FastTagDetailsViewController) {
      //  let apiManager = APIManager()
        let interactor = FastTagDetailsInteractor()
        let worker = FastTagDetailsWorker()
        let presenter = FastTagDetailsPresenter()
        let router = FastTagDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
