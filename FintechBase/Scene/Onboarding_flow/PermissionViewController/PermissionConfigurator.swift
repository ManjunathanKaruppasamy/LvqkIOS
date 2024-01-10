//
//  PermissionConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class PermissionConfigurator {
    /* Permission Configure Module */
    static func permissionConfigureModule(viewController: PermissionViewController) {
        let interactor = PermissionInteractor()
        let presenter = PermissionPresenter()
        let router = PermissionRouter()
        let worker = PermissionWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
