//
//  ResetMpinConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class ResetMpinConfigurator {
    // MARK: Configure ResetMpin scene
    static func configureModule(viewController: ResetMpinViewController) {
        let interactor = ResetMpinInteractor()
        let presenter = ResetMpinPresenter()
        let router = ResetMpinRouter()
        let worker = ResetMpinWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
