//
//  RequestSubmittedPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol RequestSubmittedPresentationLogic {
    func presentInitialUI(accountCloseScreen: AccountCloseScreen)
}

class RequestSubmittedPresenter: RequestSubmittedPresentationLogic {
    weak var viewController: RequestSubmittedDisplayLogic?
    
    // MARK: present Initial UI
    func presentInitialUI(accountCloseScreen: AccountCloseScreen) {
        self.viewController?.displayInitialUI(accountCloseScreen: accountCloseScreen)
    }
}
