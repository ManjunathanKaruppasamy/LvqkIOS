//
//  CommonMpinPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CommonMpinPresentationLogic {
    func presentMPINResponse(response: CommonMpin.CommonMpinModels.Response)
    func presentLoginMpinResponse(response: CommonMpin.CommonMpinModels.Response)
    func sendInitialSetUpData(mpinInitialData: MpinInitialData)
    func presentUserData(response: AccountDetailsRespone?)
    func updateCount(totalTime: String)
    func commonMpinPresentData(isSuccess: Bool, enteredPin: String)
    func sendValidateEmptyField(isEmpty: Bool)
    func sendCreatConfirmEmptyField(isEmpty: Bool, field: String)
    func sendCreatConfirmMatchData(isMatch: Bool)
}

class CommonMpinPresenter: CommonMpinPresentationLogic {
    weak var viewController: CommonMpinDisplayLogic?
    
    // MARK: Send Initial SetUp Data
    func sendInitialSetUpData(mpinInitialData: MpinInitialData) {
        viewController?.getInitialSetUpData(mpinInitialData: mpinInitialData)
    }
    
    // MARK: Update Timer Count
    func updateCount(totalTime: String) {
        self.viewController?.updateCount(totalTime: totalTime)
    }
    
    // MARK: Validate Enter MPIN Empty Data
    func commonMpinPresentData(isSuccess: Bool, enteredPin: String) {
        viewController?.commonMpinData(isSuccess: isSuccess, enteredPin: enteredPin)
    }
    
    // MARK: Validate Enter MPIN Data
    func sendValidateEmptyField(isEmpty: Bool) {
        self.viewController?.getValidateStatus(isEmpty: isEmpty)
    }
    
    // MARK: Validate Create/Confirm MPIN Empty Data
    func sendCreatConfirmEmptyField(isEmpty: Bool, field: String) {
        self.viewController?.getCreatConfirmEmptyStatus(isEmpty: isEmpty, field: field)
    }
    
    // MARK: Validate Create/Confirm MPIN Data
    func sendCreatConfirmMatchData(isMatch: Bool) {
        self.viewController?.getCreatConfirmMatchData(isMatch: isMatch)
    }
    
    // MARK: MPIN API Response
    func presentMPINResponse(response: CommonMpin.CommonMpinModels.Response) {
        let viewModel = CommonMpin.CommonMpinModels.ViewModel(mpinViewModelData: response.mpinResponseData)
        self.viewController?.displayMPINResponse(viewModel: viewModel)
    }
  
    // MARK: Login Mpin Response
    func presentLoginMpinResponse(response: CommonMpin.CommonMpinModels.Response) {
        let viewModel = CommonMpin.CommonMpinModels.ViewModel(loginMpinViewModelData: response.loginMpinResponseData)
        viewController?.displayLoginMpinResponse(viewModel: viewModel)
    }
    
    /* Present UserData */
    func presentUserData(response: AccountDetailsRespone?) {
        viewController?.displayUserData(response: response)
    }
}
