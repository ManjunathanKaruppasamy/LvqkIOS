//
//  VKYCWebConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 02/05/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class VKYCWebConfigurator {
    /* Configure VKYC module */
    static func configureModule(viewController: VKYCWebViewController) {
        let interactor = VKYCWebInteractor()
        let presenter = VKYCWebPresenter()
        let router = VKYCWebRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
