//
//  GenericWebConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 17/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class GenericWebConfigurator {
    // MARK: Configure the Generic Webview
    static func configureModule(viewController: GenericWebViewController) {
        let interactor = GenericWebInteractor()
        let presenter = GenericWebPresenter()
        let router = GenericWebRouter()
        let worker = GenericWebWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
