//
//  FastTagDetailsInteractor.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FastTagDetailsBusinessLogic {
    func fetchFastTagDetailsFee()
    func getGenerateHashResponse(amount: String, extTxnId: String)
    func getAddVehicleData()
}

protocol FastTagDetailsDataStore {
}

class FastTagDetailsInteractor: FastTagDetailsBusinessLogic, FastTagDetailsDataStore {
    var presenter: FastTagDetailsPresentationLogic?
    var worker: FastTagDetailsWorker?
    // var name: String = ""
    
    // MARK: Fetch fast Tag details fee
    func fetchFastTagDetailsFee() {
            worker?.fetchFastTagFee(params: [:], completion: { results, code in
                if let response = results, code == 200 {
                    let response = FastTagDetails.FastTagFeeModel.Response(fastTagFee: response)
                    self.presenter?.presentFastTagFeeResponse(response: response)
                } else {
                    showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
                }
            })
    }
    
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
    
    
    // MARK: fetch vehicle data
    func getAddVehicleData() {
        var requestDict:[String : Any] = [:]
        let idType = AddVehicleData.sharedInstace.isChasis ? "chasis" : "vrn"
        if AddVehicleData.sharedInstace.isChasis {
            requestDict = [
                "entityId": AddVehicleData.sharedInstace.vehicleNumber.removeWhitespace(),
                "idType": idType,
                "parentEntityId": ENTITYID,
                "applicantPhoto": AddVehicleData.sharedInstace.applicantPhoto,
                "insurance": AddVehicleData.sharedInstace.insurance,
                "vehicleClass": AddVehicleData.sharedInstace.vehicleClass,
                "isCommercial": AddVehicleData.sharedInstace.isCommercial
            ]
        } else {
             requestDict = [
                "entityId": AddVehicleData.sharedInstace.vehicleNumber.removeWhitespace(),
                "idType": idType,
                "parentEntityId": ENTITYID,
                "applicantPhoto": AddVehicleData.sharedInstace.applicantPhoto,
                "rcFront": AddVehicleData.sharedInstace.rcFront,
                "rcBack": AddVehicleData.sharedInstace.rcBack,
                "vehicleClass": AddVehicleData.sharedInstace.vehicleClass,
                "isCommercial": AddVehicleData.sharedInstace.isCommercial
            ] as [String: Any]
        }
        worker?.callFetchAddVehicle(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                AddVehicleData.sharedInstace.destroy()
                self.presenter?.presentAddVehicleResponse(vehicleResponse: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
}
