//
//  LogoutPresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 20/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LogoutPresentationLogic {
  func presentSomething(response: Logout.Something.Response)
}

class LogoutPresenter: LogoutPresentationLogic {
  weak var viewController: LogoutDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Logout.Something.Response) {
    let viewModel = Logout.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
