//
//  VerficationInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VerficationBusinessLogic {
    func fetchApi()
}

protocol VerficationDataStore {
     var flowFromVC: FlowFromVC { get set }
}

class VerficationInteractor: VerficationBusinessLogic, VerficationDataStore {
    var presenter: VerficationPresentationLogic?
    var worker: VerficationWorker?
    var flowFromVC: FlowFromVC = .none
    
    func fetchApi() {
        if self.flowFromVC == .accountClosure {
            self.fetchAccountClosure()
        } else if self.flowFromVC == .addVehicle {
            
        }
    }
    
    // MARK: Fetch Account closure api
    func fetchAccountClosure() {
        var requestDict: [String: String] = [:]
        if isMinKYC {
            requestDict = [
                "entityId": ENTITYID,
                "mobile": userMobileNumber,
                "closureReason": AccountClosureData.sharedInstace.closureReason,
                "bankProof": AccountClosureData.sharedInstace.bankProof,
                "idProof": AccountClosureData.sharedInstace.idProofFront,
                "idProofBack": AccountClosureData.sharedInstace.idProofBack,
                "addressProof": AccountClosureData.sharedInstace.addressProofFront,
                "addressProofBack": AccountClosureData.sharedInstace.addressProofBack,
                "accountNo": (AccountClosureData.sharedInstace.accountNo).removeWhitespace(),
                "ifscCode": AccountClosureData.sharedInstace.ifscCode
            ]
            
        } else {
            requestDict = [
                "entityId": ENTITYID,
                "mobile": userMobileNumber,
                "closureReason": AccountClosureData.sharedInstace.closureReason,
                "bankProof": AccountClosureData.sharedInstace.bankProof,
                "accountNo": (AccountClosureData.sharedInstace.accountNo).removeWhitespace(),
                "ifscCode": AccountClosureData.sharedInstace.ifscCode
            ]
        }
        
        worker?.callfetchAccountClosureApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                self.presenter?.presentAccountClosure(isSuccess: true, getAccountClosureResponseModel: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
                self.presenter?.presentAccountClosure(isSuccess: true, getAccountClosureResponseModel: nil)
            }
        })
    }
}
