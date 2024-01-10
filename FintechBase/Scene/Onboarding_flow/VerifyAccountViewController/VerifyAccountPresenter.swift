//
//  VerifyAccountPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VerifyAccountPresentationLogic {
  func presentInitialData(isFromCreateAccount: Bool)
}

class VerifyAccountPresenter: VerifyAccountPresentationLogic {
  weak var viewController: VerifyAccountDisplayLogic?
  
    func presentInitialData(isFromCreateAccount: Bool) {
        self.viewController?.displayInitialData(isFromCreateAccount: isFromCreateAccount)
    }
}
