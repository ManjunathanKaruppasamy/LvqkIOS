//
//  VerifyAadharPresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VerifyAadharPresentationLogic {
  func presentSomething(response: VerifyAadhar.Something.Response)
}

class VerifyAadharPresenter: VerifyAadharPresentationLogic {
  weak var viewController: VerifyAadharDisplayLogic?
  
  func presentSomething(response: VerifyAadhar.Something.Response) {
    let viewModel = VerifyAadhar.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
