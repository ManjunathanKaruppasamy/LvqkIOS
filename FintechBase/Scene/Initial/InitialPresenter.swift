//
//  InitialPresenter.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol InitialPresentationLogic {
    func validLaunchChecker(result: DeviceValidatorResult)
    func validKeyExchange(status: Bool)
    func presentMobileNumberKitsList(response: Initial.Fetchkits.Response)
}

class InitialPresenter: InitialPresentationLogic {
    weak var viewController: InitialDisplayLogic?
    
    // MARK: Validate Routed Device
    func validLaunchChecker(result: DeviceValidatorResult) {
        viewController?.preLaunchValidator(result: result)
    }
    
    // MARK: Key Pair Exchange
    func validKeyExchange(status: Bool) {
        viewController?.keyExchange(status: status)
    }
    
    /* Present MobileNumber Kits List */
    func presentMobileNumberKitsList(response: Initial.Fetchkits.Response) {
        let viewModel = Initial.Fetchkits.ViewModel(viewModel: response.response)
        viewController?.mobileNumberData(response: viewModel)
    }
    
}
