//
//  NegativeBalanceInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NegativeBalanceBusinessLogic {
    func getGenerateHashResponse(amount: String, extTxnId: String)
    func getBalance()
}

protocol NegativeBalanceDataStore {
    // var name: String { get set }
}

class NegativeBalanceInteractor: NegativeBalanceBusinessLogic, NegativeBalanceDataStore {
    var presenter: NegativeBalancePresentationLogic?
    var worker: NegativeBalanceWorker?
    // var name: String = ""
    
    // MARK: get Generate Hash Response
    func getGenerateHashResponse(amount: String, extTxnId: String) {
        let requestDict = [
            "txnAmount": amount,
            "extTxnId": extTxnId,
            "customerId": ENTITYID,
            "customerMobileNo": userMobileNumber
        ]
        worker?.callPayUApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                self.presenter?.presentPayuResponse(paymentParam: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    /* Get Balance */
    func getBalance() {
        CommonFunctions().fetchBalance(completion: { results, code in
            if let response = results, code == 200 {
                let response = NegativeBalance.NegativeBalanceModel.Response(getBalanceResponse: response)
                self.presenter?.presentwalletBalance(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
}
