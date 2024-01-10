//
//  TransactionDetailsInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 21/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol TransactionDetailsBusinessLogic {
    func getTransactionResponse()
}

protocol TransactionDetailsDataStore {
    var transactionDetailList: [TransactionDetailModel]? { get set }
    var transactionHistoryItem: TransactionHistoryArrayItem? { get set }
    var vehicleTransactionHistoryItem: VehicleTransactionArrayItem? { get set }
    var transactionExternalID: String? { get set }
}

class TransactionDetailsInteractor: TransactionDetailsBusinessLogic, TransactionDetailsDataStore {
    var transactionDetailList: [TransactionDetailModel]?
    var transactionHistoryItem: TransactionHistoryArrayItem?
    var vehicleTransactionHistoryItem: VehicleTransactionArrayItem?
    var transactionExternalID: String?
    var presenter: TransactionDetailsPresentationLogic?
    var worker: TransactionDetailsWorker?
    
    // MARK: get Transaction Response
    func getTransactionResponse() {
        let requestDict = [
            "extTxnId": transactionExternalID ?? ""
        ]
        
        worker?.callTransactionDetails(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                let details = self.getTransactionDetailsData(with: response.result)
                self.transactionDetailList = details
                let data = TransactionDetails.TransactionDetailsModel.Response(transactionDetailList: details, transactionModel: response)
                self.presenter?.presentTransactionDetailsData(response: data, transactionID: self.transactionExternalID ?? "", isCredit: (response.result?.transaction?.type?.lowercased() == PaymentType.status.credit ? true : false))
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: Get Transaction Details Data
    func getTransactionDetailsData(with details: TransactionResult?) -> [TransactionDetailModel] {
        var detailsArray = [TransactionDetailModel]()
        let transaction = details?.transaction
        if transaction?.networkType != "FASTAG" {
            detailsArray = [
                TransactionDetailModel(name: "Name", value: transaction?.otherPartyName ?? (transaction?.description ?? "-")),
                TransactionDetailModel(name: "Date", value: convertTimeStampToDate(date: transaction?.time)),
                TransactionDetailModel(name: "Amount", value: rupeeSymbol + " \(transaction?.amount ?? "0")" ),
                TransactionDetailModel(name: "transactionStatus", value: transaction?.transactionStatus ?? "-"),
                TransactionDetailModel(name: "transactionType", value: transaction?.type ?? "-"),
                TransactionDetailModel(name: "transactionID", value: transaction?.externalTransactionId ?? "-")
            ]
        } else {
            detailsArray = [
                TransactionDetailModel(name: "Name", value: transaction?.otherPartyName ?? (transaction?.description ?? "-")),
                TransactionDetailModel(name: "Date", value: convertTimeStampToDate(date: transaction?.time)),
                TransactionDetailModel(name: "Amount", value: rupeeSymbol + " \(transaction?.amount ?? "0")" ),
                TransactionDetailModel(name: "Vehicle type", value: transaction?.cardType ?? "-"),
                TransactionDetailModel(name: "Vehicle Number", value: transaction?.businessId ?? "-"),
                TransactionDetailModel(name: "FasTag Serial Number", value: transaction?.serialNo ?? "-"),
                TransactionDetailModel(name: "Lane Number", value: CommonFunctions().getLaneNo(name: transaction?.otherPartyId ?? "-")),
                TransactionDetailModel(name: "transactionStatus", value: transaction?.transactionStatus ?? "-"),
                TransactionDetailModel(name: "transactionType", value: transaction?.type ?? "-"),
                TransactionDetailModel(name: "transactionID", value: transaction?.externalTransactionId ?? "-")
            ]
        }
        return detailsArray
    }
}
