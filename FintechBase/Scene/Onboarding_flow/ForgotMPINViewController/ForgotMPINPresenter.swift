//
//  ForgotMPINPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 03/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ForgotMPINPresentationLogic {
  func presentForgotMPINResponse(response: ForgotMPIN.ForgotMPINModel.Response)
}

class ForgotMPINPresenter: ForgotMPINPresentationLogic {
  weak var viewController: ForgotMPINDisplayLogic?
  
  // MARK: Present ForgotMPIN Response
  func presentForgotMPINResponse(response: ForgotMPIN.ForgotMPINModel.Response) {
      let viewModel = ForgotMPIN.ForgotMPINModel.ViewModel(viewModel: response.response)
    viewController?.displayForgotMPINResponse(viewModel: viewModel)
  }
}
