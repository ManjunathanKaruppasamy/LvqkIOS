//
//  AddMoneyPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddMoneyPresentationLogic {
    func presentPayuResponse(paymentParam: PayUResponse)
    func presentCardDetails(cardDetails: GetCardResultArray?, balanceDetails: GetBalanceResult?)
//    func presentCardDetails(cardDetails: MultiCardArray?, balanceDetails: MultiCardBalance?)
}

class AddMoneyPresenter: AddMoneyPresentationLogic {
    weak var viewController: AddMoneyDisplayLogic?
    
    // MARK: Present PayU
    func presentPayuResponse(paymentParam: PayUResponse) {
        viewController?.displayPayUResponse(paymentParam: paymentParam)
    }
    /* Present CardDetails */
    func presentCardDetails(cardDetails: GetCardResultArray?, balanceDetails: GetBalanceResult?) {
        viewController?.displayCardDetails(cardDetails: cardDetails, balanceDetails: balanceDetails)
    }
//    /* Present CardDetails */
//    func presentCardDetails(cardDetails: MultiCardArray?, balanceDetails: MultiCardBalance?) {
//        viewController?.displayCardDetails(cardDetails: cardDetails, balanceDetails: balanceDetails)
//    }
}
