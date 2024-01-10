//
//  VerifyAccountInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VerifyAccountBusinessLogic {
  func getInitialData()
}

protocol VerifyAccountDataStore {
   var isFromCreateAccount: Bool { get set }
}

class VerifyAccountInteractor: VerifyAccountBusinessLogic, VerifyAccountDataStore {
  var presenter: VerifyAccountPresentationLogic?
  var worker: VerifyAccountWorker?
   var isFromCreateAccount: Bool = false
  
    func getInitialData() {
        self.presenter?.presentInitialData(isFromCreateAccount: self.isFromCreateAccount)
    }
}
