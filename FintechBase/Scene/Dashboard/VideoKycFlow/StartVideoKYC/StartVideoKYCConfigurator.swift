//
//  StartVideoKYCConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class StartVideoKYCConfigurator {
    // MARK: Configure the StartVideoKYC scene
    static func configureModule(viewController: StartVideoKYCViewController) {
        let interactor = StartVideoKYCInteractor()
        let presenter = StartVideoKYCPresenter()
        let router = StartVideoKYCRouter()
        let worker = StartVideoKYCWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
