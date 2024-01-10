//
//  NegativeBalancePresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NegativeBalancePresentationLogic {
    func presentPayuResponse(paymentParam: PayUResponse)
    func presentwalletBalance(response: NegativeBalance.NegativeBalanceModel.Response)
}

class NegativeBalancePresenter: NegativeBalancePresentationLogic {
    weak var viewController: NegativeBalanceDisplayLogic?
    
    // MARK: Present PayU
    func presentPayuResponse(paymentParam: PayUResponse) {
        viewController?.displayPayUResponse(paymentParam: paymentParam)
    }
    
    // MARK: Wallet Balance Response
    func presentwalletBalance(response: NegativeBalance.NegativeBalanceModel.Response) {
        let viewModel = NegativeBalance.NegativeBalanceModel.ViewModel(getBalanceResponse: response.getBalanceResponse)
        viewController?.displayWalletBalanceResponse(viewModel: viewModel)
    }
}
