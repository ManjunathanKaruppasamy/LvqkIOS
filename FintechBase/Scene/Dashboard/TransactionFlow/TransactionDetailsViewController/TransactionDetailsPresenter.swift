//
//  TransactionDetailsPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 21/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol TransactionDetailsPresentationLogic {
    func presentTransactionDetailsData(response: TransactionDetails.TransactionDetailsModel.Response, transactionID: String, isCredit: Bool)
}

class TransactionDetailsPresenter: TransactionDetailsPresentationLogic {
  weak var viewController: TransactionDetailsDisplayLogic?
  
  // MARK: Present Transaction Details Data
  func presentTransactionDetailsData(response: TransactionDetails.TransactionDetailsModel.Response, transactionID: String, isCredit: Bool) {
      let viewModel = TransactionDetails.TransactionDetailsModel.ViewModel(transactionDetailList: response.transactionDetailList, transactionModel: response.transactionModel)
    viewController?.displayTransactionDetailsData(viewModel: viewModel, transactionID: transactionID, isCredit: isCredit)
  }
}
