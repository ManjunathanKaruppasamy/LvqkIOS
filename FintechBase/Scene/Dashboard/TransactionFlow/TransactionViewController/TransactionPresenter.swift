//
//  TransactionPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol TransactionPresentationLogic {
    func presentDateFilterData(filterListData: [FilterListData])
    func presentTransactionHistoryData(data: TransactionHistoryModel?)
    func presentTransactionID()
}

class TransactionPresenter: TransactionPresentationLogic {
  weak var viewController: TransactionDisplayLogic?
  
    // MARK: Present Date Filter Data
    func presentDateFilterData(filterListData: [FilterListData]) {
        self.viewController?.displayDateFilterData(filterListData: filterListData)
    }
    
    func presentTransactionHistoryData(data: TransactionHistoryModel?) {
        viewController?.displayTransactionHistoryData(data: data)
    }
    
    // MARK: Push To transactionDetails VC
    func presentTransactionID() {
        viewController?.displayTxnExternalID()
    }
}
