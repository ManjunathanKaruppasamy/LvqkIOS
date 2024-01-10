//
//  TransactionInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

protocol TransactionBusinessLogic {
    func setDateFilterData()
    func setFilterByData()
    func fetchTransactionHistoryList(isDateSelected: Bool, fromDate: String, toDate: String, pageNumber: Int)
    func getExternalTransactionId(id: String)
}

protocol TransactionDataStore {
    var dateFilterListData: [FilterListData]? { get set }
    var filterByListData: [FilterListData]? { get set }
    var filterState: FilterState? { get set }
    var transactionExternalID: String? { get set }
}

class TransactionInteractor: TransactionBusinessLogic, TransactionDataStore {
    var presenter: TransactionPresentationLogic?
    var worker: TransactionWorker?
    var filterByListData: [FilterListData]?
    var dateFilterListData: [FilterListData]?
    var filterState: FilterState?
    var transactionExternalID: String?
    
    // MARK: Set Date Filter Data
    func setDateFilterData() {
        self.dateFilterListData = [FilterListData(title: "Current Month", month: 0),
                               FilterListData(title: "Last Month", month: 1),
                               FilterListData(title: "Last 3 Months", month: 3),
                               FilterListData(title: "Last 6 Months", month: 6),
                               FilterListData(title: "Custom date range", month: -1)]
        self.presenter?.presentDateFilterData(filterListData: self.dateFilterListData ?? [])
    }
    
    // MARK: Set FilterBy Data
    func setFilterByData() {
        self.filterByListData = [FilterListData(title: "Toll"),
                               FilterListData(title: "Fuel"),
                               FilterListData(title: "Food"),
                               FilterListData(title: "Others"),
                               FilterListData(title: "All Credit Transactions")]
//        self.presenter?.presentDateFilterData(filterListData: self.filterListData ?? [])
    }
    
    func fetchTransactionHistoryList(isDateSelected: Bool, fromDate: String, toDate: String, pageNumber: Int = 0) {
        CommonFunctions().fetchTransactionHistory(isDateSelected: isDateSelected, fromDate: fromDate, toDate: toDate, pageSize: "200", pageNumber: "\(pageNumber)", completion: { response, code in
            if let responseData = response, code == 200 {
                self.presenter?.presentTransactionHistoryData(data: responseData)
            } else {
                self.presenter?.presentTransactionHistoryData(data: response)
            }
        })
    }
    
    // MARK: Get External Transaction id
    func getExternalTransactionId(id: String) {
        self.transactionExternalID = id
        self.presenter?.presentTransactionID()
    }
}
