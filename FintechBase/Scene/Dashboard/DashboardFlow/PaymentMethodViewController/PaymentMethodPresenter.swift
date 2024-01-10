//
//  PaymentMethodPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 13/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PaymentMethodPresentationLogic {
    func passInitialValue(amount: String)
}

class PaymentMethodPresenter: PaymentMethodPresentationLogic {
  weak var viewController: PaymentMethodDisplayLogic?
  
  // MARK: Pass Initial Value
    func passInitialValue(amount: String) {
        self.viewController?.displayInitialValue(amount: amount)
    }
}
