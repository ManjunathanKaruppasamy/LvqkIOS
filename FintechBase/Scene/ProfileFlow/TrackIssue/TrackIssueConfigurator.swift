//
//  TrackIssueConfigurator.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 07/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

class TrackIssueConfigurator {
    // MARK: Configure TrackList Scene
    static func configureModule(viewController: TrackIssueViewController) {
        let interactor = TrackIssueInteractor()
        let presenter = TrackIssuePresenter()
        let router = TrackIssueRouter()
        let worker = TrackIssueWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
