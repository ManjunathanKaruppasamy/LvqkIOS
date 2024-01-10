//
//  NoInternetConfigurator.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 10/07/22.
//

import Foundation
import UIKit

class NoInternetConfigurator {
    
    static func configureModule(viewController: NoInternetViewController) {
        let interactor = NoInternetInteractor()
        let presenter = NoInternetPresenter()
        let router = NoInternetRouter()
        let worker = NoInternetWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
