//
//  RequestSubmittedInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol RequestSubmittedBusinessLogic {
    func setUpInitialUI()
}

protocol RequestSubmittedDataStore {
     var accountCloseScreen: AccountCloseScreen? { get set }
}

class RequestSubmittedInteractor: RequestSubmittedBusinessLogic, RequestSubmittedDataStore {
    var presenter: RequestSubmittedPresentationLogic?
    var worker: RequestSubmittedWorker?
    var accountCloseScreen: AccountCloseScreen?
    
    // MARK: SetUp Initial UI
    func setUpInitialUI() {
        self.presenter?.presentInitialUI(accountCloseScreen: self.accountCloseScreen ?? .submitted)
    }
}
