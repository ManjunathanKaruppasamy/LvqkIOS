//
//  UPIAppsBottomSheetConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/06/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class UPIAppsBottomSheetConfigurator {
    static func configureModule(viewController: UPIAppsBottomSheetViewController) {
        let interactor = UPIAppsBottomSheetInteractor()
        let presenter = UPIAppsBottomSheetPresenter()
        let router = UPIAppsBottomSheetRouter()
        let worker = UPIAppsBottomSheetWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
