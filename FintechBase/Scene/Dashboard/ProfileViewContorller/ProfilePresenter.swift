//
//  ProfilePresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfilePresentationLogic {
  func presentSomething(response: Profile.Something.Response)
}

class ProfilePresenter: ProfilePresentationLogic {
  weak var viewController: ProfileDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Profile.Something.Response) {
    let viewModel = Profile.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
