//
//  VerifyOTPInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

protocol VerifyOTPBusinessLogic {
  func startTimer()
  func getUIAttributes()
  func genrerateOTP()
  func getValidateOTP(otp: String)
  func stopTimer()
  func emptyOtpCheck(otp: String)
  func updateEmail()
}

protocol VerifyOTPDataStore {
  // var name: String { get set }
    var flowEnum: ModuleFlowEnum { get set }
    var email: String { get set }
}

class VerifyOTPInteractor: VerifyOTPBusinessLogic, VerifyOTPDataStore {
  var presenter: VerifyOTPPresentationLogic?
  var worker: VerifyOTPWorker?
  var flowEnum: ModuleFlowEnum = .none
  var email: String = ""
  
   // MARK: Start Timer
    func startTimer() {
        worker?.callTimer(countDownVal: 45, completion: { updateCountDown in
            self.presenter?.presentTimerCount(totalTime: updateCountDown)
        })
    }
    
    // MARK: Get UI Attributes
    func getUIAttributes() {
        presenter?.presentUIAttributes(flowEnum: self.flowEnum)
    }
    
    // MARK: Stop Timer
    func stopTimer() {
        worker?.endTimer()
    }
    
    // MARK: Get OTP
    func genrerateOTP() {
        let requestDict = [
            "mobile": userMobileNumber
        ]

        worker?.callGetOTPApi(params: requestDict as Parameters, completion: { results, code in
            if let response = results, code == 200 {
                let response = VerifyOTP.OTPModel.Response(getOTPResponse: response)
                self.presenter?.presentGenerateOTPResponse(response: response)
            }
        })
    }
    
    // MARK: Validate OTP
    func getValidateOTP(otp: String) {
        let requestDict = [
            "mobileNumber": userMobileNumber,
            "otp": otp
        ]

        worker?.callValidateOTPApi(params: requestDict as Parameters, completion: { results, code in
            if let response = results, code == 200 {
                let response = VerifyOTP.OTPModel.Response(validateOTPResponse: response)
                self.presenter?.presentValidateOTPResponse(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: Empty OTP
    func emptyOtpCheck(otp: String) {
        if otp.contains("$") || otp.count < 6 {
            presenter?.presentEmptyOtpResponse(isValid: false)
        } else {
            presenter?.presentEmptyOtpResponse(isValid: true)
        }
    }
    
   /* Update Email Api Request*/
    func updateEmail() {
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
