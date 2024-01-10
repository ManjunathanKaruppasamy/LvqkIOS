//
//  AccountClosurePresenter.swift
//  FintechBase
//
//  Created by Sravani Madala on 26/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AccountClosurePresentationLogic {
    func presentRequestCallBackresponse(response: AccountClosure.AccountModel.Response)
}

class AccountClosurePresenter: AccountClosurePresentationLogic {
    weak var viewController: AccountClosureDisplayLogic?
    
    // MARK: Vehicle List Response
    func presentRequestCallBackresponse(response: AccountClosure.AccountModel.Response) {
        self.viewController?.displayRequestCallBackresponse(response: AccountClosure.AccountModel.ViewModel(viewModel: response.response))
    }
}
