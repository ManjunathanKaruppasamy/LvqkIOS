//
//  AadhaarVerificationPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/11/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AadhaarVerificationPresentationLogic {
    func presentSomething(response: AadhaarVerification.Something.Response)
}

class AadhaarVerificationPresenter: AadhaarVerificationPresentationLogic {
    weak var viewController: AadhaarVerificationDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: AadhaarVerification.Something.Response) {
        let viewModel = AadhaarVerification.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
