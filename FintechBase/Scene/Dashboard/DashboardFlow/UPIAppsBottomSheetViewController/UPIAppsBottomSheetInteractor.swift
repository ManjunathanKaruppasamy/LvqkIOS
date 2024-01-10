//
//  UPIAppsBottomSheetInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/06/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UPIAppsBottomSheetBusinessLogic {
    func getUPIAppsList()
    func getReferenceIdApi()
    func fetchTransactionByTxnIdApi(transactionID: String?, refId: String?)
}

protocol UPIAppsBottomSheetDataStore {
    var amount: String? { get set }
}

class UPIAppsBottomSheetInteractor: UPIAppsBottomSheetBusinessLogic, UPIAppsBottomSheetDataStore {
    var presenter: UPIAppsBottomSheetPresentationLogic?
    var worker: UPIAppsBottomSheetWorker?
    var amount: String?
    
    // MARK: get UPI Apps List
    
    func getUPIAppsList() {
        var upiApps = [UPIAppsData]()
        guard let upiURL = URL(string: "upi://") else {
            return
        }
        let canOpenUPI = UIApplication.shared.canOpenURL(upiURL)
        if canOpenUPI {
        
            let upiAppSchemes: [UPIAppsData] = [UPIAppsData(name: "Paytm", urlScheme: "paytm", pushURL: "paytm://upi/"),
                                                UPIAppsData(name: "Phonepe", urlScheme: "phonepe", pushURL: "phonepe://upi/"),
                                                UPIAppsData(name: "Gpay", urlScheme: "gpay", pushURL: "gpay://upi/"),
                                                UPIAppsData(name: "Amazon", urlScheme: "com.amazon.mobile.shopping", pushURL: "com.amazon.mobile.shopping://upi/")]
            
            for scheme in upiAppSchemes {
                guard let appURL = URL(string: "\(scheme.urlScheme ?? "")://") else {
                    return
                }
                let canOpenApp = UIApplication.shared.canOpenURL(appURL)
                
                if canOpenApp {
                    upiApps.append(scheme)
                    presenter?.presentUPIAppsList(upiAppsList: upiApps)
                }
            }
        } else {
//            print("No UPI apps found on the device.")
            presenter?.presentUPIAppsList(upiAppsList: [])
        }
        
    }
    
    // MARK: Get Reference Id Api
    func getReferenceIdApi() {
        let amount = ["curr": "INR",
                      "value": self.amount ?? "0"]
        
        let requestDict = [
            "channelCode": "UPIADDMONEY",
            "tenant": "LQFLEET",
            "productId": "GENERAL",
            "profileId": "LqfleetAddmoney",
            "entityId": ENTITYID,
            "amount": amount ] as [String: Any]
        
        worker?.callGetReferenceIdApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                if  response.status?.uppercased() == "SUCCESS" {
                    self.presenter?.presentGetReferenceId(response: UPIAppsBottomSheet.UPIAppsBottomSheetModel.Response(getReferenceIdResponse: response))
                } else {
                    showSuccessToastMessage(message: response.exception?.detailMessage ?? AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
                }
            } else {
                showSuccessToastMessage(message: results?.exception?.detailMessage ?? AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: fetch Transaction By TxnId Api
    func fetchTransactionByTxnIdApi(transactionID: String?, refId: String?) {
        let requestDict = [
            "txnSubType": "CREDIT",
            "txnId": transactionID ?? "",
            "refId": refId ?? ""] as [String: Any]
        
        worker?.callFetchTransactionByTxnIdApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                self.presenter?.presentTransactionDetails(response: UPIAppsBottomSheet.UPIAppsBottomSheetModel.Response(fetchTransactionResponse: response))
                
            } else {
                showSuccessToastMessage(message: results?.exception?.detailMessage ?? AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
}
