//
//  ResetMpinInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

protocol ResetMpinBusinessLogic {
    func validateMpinMatch(newMpinText: String, reEnterMpinText: String)
    func validateMPinText( newMPinText: String, reEnterMpinText: String)
    func updateMpinText(newMpin: String)
}

protocol ResetMpinDataStore {
    var flowEnum: ModuleFlowEnum { get set }
}

class ResetMpinInteractor: ResetMpinBusinessLogic, ResetMpinDataStore {
    var presenter: ResetMpinPresentationLogic?
    var worker: ResetMpinWorker?
    var flowEnum: ModuleFlowEnum = .none
    
    // MARK: Validate MpinMatch
    func validateMpinMatch(newMpinText: String, reEnterMpinText: String) {
        if newMpinText == reEnterMpinText {
            presenter?.presentMpinMatchConfirmation(isMatch: true, responseMsg: AppLoacalize.textString.success, newPin: reEnterMpinText)
        } else {
            presenter?.presentMpinMatchConfirmation(isMatch: false, responseMsg: AppLoacalize.textString.failure, newPin: "")
        }
    }
    
    // MARK: Validate Empty Mpin
    func validateMPinText( newMPinText: String, reEnterMpinText: String) {
        if newMPinText.contains("$") {
            presenter?.presentValidateMpinText(isEmpty: true, mpinText: newMPinText)
        } else if reEnterMpinText.contains("$") {
            presenter?.presentValidateMpinText(isEmpty: true, mpinText: newMPinText)
        } else {
            if newMPinText == reEnterMpinText {
                presenter?.presentMpinMatchConfirmation(isMatch: true, responseMsg: AppLoacalize.textString.success, newPin: reEnterMpinText)
            } else {
                presenter?.presentMpinMatchConfirmation(isMatch: false, responseMsg: AppLoacalize.textString.failure, newPin: "")
            }
        }
    }
    
    // MARK: Update Mpin
    func updateMpinText(newMpin: String) {
        let keyValueDict: Parameters = [
            "mpin": newMpin
        ]
        
        let requestDict: Parameters = [
            "mobile": userMobileNumber,
            "keyValue": keyValueDict
        ]
        worker?.callUpdateMpinApi(params: requestDict, completion: { result, code in
            if let response = result, code == 200, response.status == APIStatus.statusString.success {
                userMobileNumber = userMobileNumber
                self.presenter?.presentUpdateMpinConfirmation(response: response)
            } else {
                self.presenter?.presentUpdateMpinConfirmation(response: result)
            }
        })
    }
}
