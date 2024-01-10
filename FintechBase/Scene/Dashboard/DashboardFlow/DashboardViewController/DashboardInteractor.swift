//
//  DashboardInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 08/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

protocol DashboardBusinessLogic {
    func fetchCardList()
//    func fetchMultiCardList()
    func fetchBalance()
    func fetchVehicleList()
    func fetchTransactionHistory(isDateSelected: Bool, fromDate: String, toDate: String)
    func getUserData()
    func setDataForVehicleDetailsVC(vehicleStatus: VehicleStatus, vehicleListResultArray: VehicleListResultArray)
    func getExternalTransactionId(id: String)
    func getBannerList()
    func storeSelectedCardDetails(cardData: GetCardResultArray?, balanceDetails: GetBalanceResult?)
//    func storeSelectedCardDetails(cardData: MultiCardArray?, balanceDetails: MultiCardBalance?)
}

protocol DashboardDataStore {
    var vehicleStatus: VehicleStatus? { get set }
    var vehicleListResultArray: VehicleListResultArray? { get set }
    var transactionExternalID: String? { get set }
    var selectedCardDetails: GetCardResultArray? { get set }
    var selectedCardBalance: GetBalanceResult? { get set }
//    var selectedCardDetails: MultiCardArray? { get set }
//    var selectedCardBalance: MultiCardBalance? { get set }
}

class DashboardInteractor: DashboardBusinessLogic, DashboardDataStore {
    var presenter: DashboardPresentationLogic?
    var worker: DashboardWorker?
    var vehicleStatus: VehicleStatus?
    var vehicleListResultArray: VehicleListResultArray?
    var transactionExternalID: String?
    var selectedCardDetails: GetCardResultArray?
    var selectedCardBalance: GetBalanceResult?
//    var selectedCardDetails: MultiCardArray?
//    var selectedCardBalance: MultiCardBalance?
    
    // MARK: Set Data For VehicleDetails VC
    func setDataForVehicleDetailsVC(vehicleStatus: VehicleStatus, vehicleListResultArray: VehicleListResultArray) {
        self.vehicleStatus = vehicleStatus
        self.vehicleListResultArray = vehicleListResultArray
        self.presenter?.pushToVehicleDetailsVC()
    }
    
    // MARK: Fetch Transaction History
    func getUserData() {
       let requestDict = [
        "mobile": userMobileNumber
          ]
        worker?.callFetchCustomer(params: requestDict, completion: { response, code in
            if let responseData = response, code == 200 {
                ENTITYID = responseData.result?.entityid ?? ""
                CORPORATE = responseData.result?.customerType ?? ""
                DOB = responseData.result?.dob ?? ""
                userName = responseData.result?.name ?? ""
                EMAIL = responseData.result?.email ?? ""
                self.presenter?.presentUserData(response: responseData)
            } else {
                self.presenter?.presentUserData(response: response)
            }
        })
    }
    
    /* Fetch Transaction History */
    func fetchTransactionHistory(isDateSelected: Bool, fromDate: String, toDate: String) {
        CommonFunctions().fetchTransactionHistory(isDateSelected: isDateSelected, fromDate: fromDate, toDate: toDate, pageSize: "5", pageNumber: "0", completion: { response, code in
            if let responseData = response, code == 200 {
                self.presenter?.presentTransactionHistory(data: responseData)
            } else {
                self.presenter?.presentTransactionHistory(data: response)
            }
        })
    }
    
    // MARK: Fetch Wallet Balance
    func fetchBalance() {
        CommonFunctions().fetchBalance(completion: { results, code in
            if let response = results, code == 200 {
                let response = Dashboard.DashboardModel.Response(getBalanceResponse: response)
                self.presenter?.presentwalletBalance(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: Fetch Vehicle List
    func fetchVehicleList() {
        let requestDict = [
            "entityType": entityType,
            "pageSize": "200",
            "pageNumber": "0",
            "parentEntityId": ENTITYID
        ]
        
        worker?.callfetchVehicleListApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                let response = Dashboard.DashboardModel.Response(vehicleListResponse: response, upiListData: self.getUpiList())
                self.presenter?.presentVehicleListresponse(response: response)
            } else {
                let response = Dashboard.DashboardModel.Response(upiListData: self.getUpiList())
                self.presenter?.presentVehicleListresponse(response: response)
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    func getUpiList() -> [UPIListData] {
        let upiListData = [UPIListData(title: AppLoacalize.textString.scanAndPay, image: Image.imageString.scanPay),
                           UPIListData(title: AppLoacalize.textString.payUPIID, image: Image.imageString.payUpiId),
                           UPIListData(title: AppLoacalize.textString.bankTransfer, image: Image.imageString.bankTransfer),
                           UPIListData(title: AppLoacalize.textString.requestMoney, image: Image.imageString.requestMoney),
                           UPIListData(title: AppLoacalize.textString.transactionHistoryTitle, image: Image.imageString.transactionHistory)]
        return upiListData
    }
    
    // MARK: Get Card List
    func fetchCardList() {
        let requestDict = [
            "entityId": ENTITYID
        ]

        worker?.callGetCardListApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                let response = Dashboard.DashboardModel.Response(getCardResponse: response)
                self.presenter?.presentGetCardList(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: Get Multi Card List
//    func fetchMultiCardList() {
//        let requestDict = [
//            "mobile": userMobileNumber,
//            "entityId": ENTITYID
//        ]
//
//        worker?.callGetMultiCardListApi(params: requestDict, completion: { results, code in
//            if let response = results, code == 200 {
//                let response = Dashboard.DashboardModel.Response(getMultiCardResponse: response)
//                self.presenter?.presentGetMultiCardList(response: response)
//            } else {
//                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
//            }
//        })
//    }
    
    // MARK: Get External Transaction id
    func getExternalTransactionId(id: String) {
        self.transactionExternalID = id
        self.presenter?.pushToTransactionDetailsVc()
    }
    
    /* Get Banner List */
    func getBannerList() {
        worker?.getBannerList(params: [:], completion: { results, code in
            if let response = results, code == 200 {
                let response = Dashboard.DashboardModel.Response(getBannerListResponse: response)
                self.presenter?.presentGetBannerListResponse(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    /* Save Selected Card Details */
//    func storeSelectedCardDetails(cardData: MultiCardArray?, balanceDetails: MultiCardBalance?) {
//        self.selectedCardDetails = cardData
//        self.selectedCardBalance = balanceDetails
//        self.presenter?.presentSelectedCardDetails()
//    }
    /* Save Selected Card Details */
    func storeSelectedCardDetails(cardData: GetCardResultArray?, balanceDetails: GetBalanceResult?) {
        self.selectedCardDetails = cardData
        self.selectedCardBalance = balanceDetails
        self.presenter?.presentSelectedCardDetails()
    }
}
