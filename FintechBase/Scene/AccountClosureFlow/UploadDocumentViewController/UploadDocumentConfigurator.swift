//
//  UploadDocumentConfigurator.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class UploadDocumentConfigurator {
    static func configureModule(viewController: UploadDocumentViewController) {
//        let apiManager = APIManager()
        let interactor = UploadDocumentInteractor()
        let worker = UploadDocumentWorker()
        let presenter = UploadDocumentPresenter()
        let router = UploadDocumentRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
