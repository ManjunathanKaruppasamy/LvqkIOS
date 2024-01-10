//
//  AccountDetailsPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AccountDetailsPresentationLogic {
    func customerRegisterResponse(response: AccountDetails.FetchList.Response)
    func listAccountDetailsDataResponse(data: AccountDetails.FetchList.Response, flowEnum: ModuleFlowEnum, userState: UserState)
}

class AccountDetailsPresenter: AccountDetailsPresentationLogic {
  weak var viewController: AccountDetailsDisplayLogic?

    /* Preesent Account Details list */
    func listAccountDetailsDataResponse(data: AccountDetails.FetchList.Response, flowEnum: ModuleFlowEnum, userState: UserState) {
        let viewModel = AccountDetails.FetchList.ViewModel(accountDetails: data.accountDetails, accountDetailsViewModel: data.accountDetailsRespone)
        viewController?.listAccountDetailsData(data: viewModel, flowEnum: flowEnum, userState: userState)
    }
    func customerRegisterResponse(response: AccountDetails.FetchList.Response) {
        self.viewController?.displayCustomerRegisterResponse(viewModel: AccountDetails.FetchList.ViewModel(registerUserResponseData: response.registerUserResponseData))
    }
}
