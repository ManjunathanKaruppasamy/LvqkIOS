//
//  AddMoneyInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddMoneyBusinessLogic {
    func getGenerateHashResponse(amount: String, extTxnId: String)
    func getBalanceForCard()
}

protocol AddMoneyDataStore {
    var name: String { get set }
    var amount: String { get set }
    var selectedCardResult: GetCardResultArray? { get set }
    var selectedCardBalance: GetBalanceResult? { get set }
//    var selectedCardResult: MultiCardArray? { get set }
//    var selectedCardBalance: MultiCardBalance? { get set }
}

class AddMoneyInteractor: AddMoneyBusinessLogic, AddMoneyDataStore {
    var presenter: AddMoneyPresentationLogic?
    var worker: AddMoneyWorker?
    var name: String = ""
    var amount: String = ""
    var selectedCardResult: GetCardResultArray?
    var selectedCardBalance: GetBalanceResult?
//    var selectedCardResult: MultiCardArray?
//    var selectedCardBalance: MultiCardBalance?
    
    // MARK: get Generate Hash Response
    func getGenerateHashResponse(amount: String, extTxnId: String) {
        let requestDict = [
            "txnAmount": amount,
            "extTxnId": extTxnId,
            "customerId": ENTITYID,
            "productId": "GENERAL",
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
    
    /* Get Balance For Card */
    func getBalanceForCard() {
        self.presenter?.presentCardDetails(cardDetails: self.selectedCardResult, balanceDetails: self.selectedCardBalance)
        let requestDict = [
            "mobile": ENTITYID
        ]
        worker?.callfetchBalanceApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                self.selectedCardBalance = response.result?.first
                self.presenter?.presentCardDetails(cardDetails: self.selectedCardResult, balanceDetails: self.selectedCardBalance)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
}
