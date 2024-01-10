//
//  PayUPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 24/04/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PayUPresentationLogic {
    func presentLoadLink(linkString: String, isAccountClose: Bool)
}

class PayUPresenter: PayUPresentationLogic {
  weak var viewController: PayUDisplayLogic?
  
  // MARK: Present PayU Entry Link
  func presentLoadLink(linkString: String, isAccountClose: Bool) {
    viewController?.displayLoadLink(linkString: linkString, isAccountClose: isAccountClose)
  }
}
