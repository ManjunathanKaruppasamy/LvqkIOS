//
//  BankAccountDetailsPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BankAccountDetailsPresentationLogic {
    func presentFieldDetails(accountDetailsField: [AccountDetailsField])
}

class BankAccountDetailsPresenter: BankAccountDetailsPresentationLogic {
    weak var viewController: BankAccountDetailsDisplayLogic?
    
    // MARK: present Field Details
    func presentFieldDetails(accountDetailsField: [AccountDetailsField]) {
        self.viewController?.displayFieldDetails(accountDetailsField: accountDetailsField)
    }
}
