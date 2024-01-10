//
//  ResetMpinPresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ResetMpinPresentationLogic {
  func presentValidateMpinText(isEmpty: Bool, mpinText: String)
  func presentMpinMatchConfirmation(isMatch: Bool, responseMsg: String, newPin: String)
  func presentUpdateMpinConfirmation(response: MPINResponseData?)
}

class ResetMpinPresenter: ResetMpinPresentationLogic {
  weak var viewController: ResetMpinDisplayLogic?
  
  // MARK: Present ValidateMpinText
    func presentValidateMpinText(isEmpty: Bool, mpinText: String) {
        viewController?.displayValidateNewMpinText(isEmpty: isEmpty, mpinText: mpinText)
    }
    
    // MARK: Present MpinMatchConfirmation
    func presentMpinMatchConfirmation(isMatch: Bool, responseMsg: String, newPin: String) {
        viewController?.displayResetMpinMatchResponse(isMatch: isMatch, responseMsg: responseMsg, newMpin: newPin)
    }
    
    // MARK: Present UpdateMpinConfirmation
    func presentUpdateMpinConfirmation(response: MPINResponseData?) {
        viewController?.displayUpdateMpinResponse(response: response)
    }
}
