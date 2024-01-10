//
//  UpdateEmailInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

protocol UpdateEmailBusinessLogic {
  func validateEmailCheck(request: UpdateEmail.Validate.Request)
  func getUpdateEmailApiResponse(email: String)
}

protocol UpdateEmailDataStore {
    var email: String { get set }
    var flowEnum: ModuleFlowEnum { get set }
}

class UpdateEmailInteractor: UpdateEmailBusinessLogic, UpdateEmailDataStore {
  var presenter: UpdateEmailPresentationLogic?
  var worker: UpdateEmailWorker?
  var flowEnum: ModuleFlowEnum = .none
  var email: String = ""
  
  // MARK: Confirm The Match
  func validateEmailCheck(request: UpdateEmail.Validate.Request) {
      if let mailOne = request.newEmailID, let mailTwo = request.reEnteredEmailID, !mailOne.isEmpty || !mailTwo.isEmpty {
          if request.newEmailID == request.reEnteredEmailID {
              let response = UpdateEmail.Validate.Response(isEmailValidation: true, responseMsg: AppLoacalize.textString.emailUpdateSuccess, email: mailOne)
              self.email = mailOne
              presenter?.presentUpdatedEmailData(response: response)
          } else {
              let response = UpdateEmail.Validate.Response(isEmailValidation: false, responseMsg: AppLoacalize.textString.emailMismatch, email: mailOne )
              presenter?.presentUpdatedEmailData(response: response)
          }
      } else {
          let response = UpdateEmail.Validate.Response(isEmailValidation: false, responseMsg: AppLoacalize.textString.emailFailure, email: request.newEmailID ?? "")
          presenter?.presentUpdatedEmailData(response: response)
      }
    }
    
    // MARK: Update Email Api 
    func getUpdateEmailApiResponse(email: String) {
        let keyValueDict: Parameters = [
            "email": self.email
          ]
          let requestDict: Parameters = [
            "mobile": userMobileNumber,
            "keyValue": keyValueDict
          ]
        worker?.callUpdateEmailApi(params: requestDict, completion: { result, code in
            
            if let responseData = result, code == StatusCode.code.success {
                self.presenter?.presentUpdateEmailApiResponse(response: responseData)
            } else {
                self.presenter?.presentUpdateEmailApiResponse(response: result)
            }
        })
    }
}
