//
//  FilterListBottomSheetConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class FilterListBottomSheetConfigurator {
    /* Configure FilterListBottom scene */
    static func configureModule(viewController: FilterListBottomSheetViewController) {
        let interactor = FilterListBottomSheetInteractor()
        let presenter = FilterListBottomSheetPresenter()
        let router = FilterListBottomSheetRouter()
        let worker = FilterListBottomSheetWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
