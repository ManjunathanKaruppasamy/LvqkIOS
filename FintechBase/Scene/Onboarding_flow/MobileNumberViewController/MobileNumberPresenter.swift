//
//  MobileNumberPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol MobileNumberPresentationLogic {
    func presentMobileNumberKitsList(response: MobileNumberModel.Customer.Response)
    func presentDigiLockerResponse()
}

class MobileNumberPresenter: MobileNumberPresentationLogic {
    weak var viewController: MobileNumberDisplayLogic?
    
    /* Present MobileNumber Kits List */
    func presentMobileNumberKitsList(response: MobileNumberModel.Customer.Response) {
        let viewModel = MobileNumberModel.Customer.ViewModel(viewModel: response.response)
        viewController?.mobileNumberData(response: viewModel)
    }
    
    /* present Digi Locker Response*/
    func presentDigiLockerResponse() {
        viewController?.displayDigiLockerResponse()
    }
    
}
