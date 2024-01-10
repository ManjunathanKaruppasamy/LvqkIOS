//
//  PaymentMethodInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 13/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PaymentMethodBusinessLogic {
  func getInitialValue()
}

protocol PaymentMethodDataStore {
  var amount: String? { get set }
}

class PaymentMethodInteractor: PaymentMethodBusinessLogic, PaymentMethodDataStore {
  var presenter: PaymentMethodPresentationLogic?
  var worker: PaymentMethodWorker?
  var amount: String?
  
    // MARK: Get Initial Values
    func getInitialValue() {
        self.presenter?.passInitialValue(amount: self.amount ?? "")
    }
}
