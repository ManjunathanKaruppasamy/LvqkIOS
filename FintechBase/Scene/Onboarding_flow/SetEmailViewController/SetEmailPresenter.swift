//
//  SetEmailPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SetEmailPresentationLogic {
    func presentSomething(response: SetEmail.Something.Response)
}

class SetEmailPresenter: SetEmailPresentationLogic {
    weak var viewController: SetEmailDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: SetEmail.Something.Response) {
        let viewModel = SetEmail.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
