//
//  WalkThroughPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol WalkThroughPresentationLogic {
  func presentSomething(response: WalkThrough.Something.Response)
}

class WalkThroughPresenter: WalkThroughPresentationLogic {
  weak var viewController: WalkThroughDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: WalkThrough.Something.Response) {
    let viewModel = WalkThrough.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
