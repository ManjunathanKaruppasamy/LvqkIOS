//
//  AddAddressPresenter.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddAddressPresentationLogic {
    func presentSomething(response: AddAddress.Something.Response)
}

class AddAddressPresenter: AddAddressPresentationLogic {
    weak var viewController: AddAddressDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: AddAddress.Something.Response) {
        let viewModel = AddAddress.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
