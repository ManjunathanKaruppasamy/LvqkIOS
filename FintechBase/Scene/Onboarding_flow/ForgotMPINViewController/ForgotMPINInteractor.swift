//
//  ForgotMPINInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 03/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ForgotMPINBusinessLogic {
  func getForgotMPINResponse(request: ForgotMPIN.ForgotMPINModel.Request)
}

protocol ForgotMPINDataStore {
  // var name: String { get set }
}

class ForgotMPINInteractor: ForgotMPINBusinessLogic, ForgotMPINDataStore {
  var presenter: ForgotMPINPresentationLogic?
  var worker: ForgotMPINWorker?
  // var name: String = ""
  
  // MARK: Get ForgotMPIN Response
  func getForgotMPINResponse(request: ForgotMPIN.ForgotMPINModel.Request) {
      let requestDict = [
        "mobile": request.forgotMPINRequest?.mobile ?? "",
        "dob": request.forgotMPINRequest?.dob ?? ""
      ]
      
      worker?.callForgotMPIN(params: requestDict, completion: { results, code in
          if let response = results, code == 200 {
              let response = ForgotMPIN.ForgotMPINModel.Response(response: response)
              self.presenter?.presentForgotMPINResponse(response: response)
          } else {
              showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
          }
      })
  }
}
