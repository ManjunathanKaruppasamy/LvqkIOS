//
//  FitmentCertificateConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class FitmentCertificateConfigurator {
    /* Configure Fitment Certificate scene */
    static func configureModule(viewController: FitmentCertificateViewController) {
        let interactor = FitmentCertificateInteractor()
        let presenter = FitmentCertificatePresenter()
        let router = FitmentCertificateRouter()
        let worker = FitmentCertificateWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
