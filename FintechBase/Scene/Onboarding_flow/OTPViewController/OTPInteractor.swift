//
//  OTPInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

protocol OTPBusinessLogic {
    func getMobileNumber()
    func getOTP()
    func getValidateOTP(otp: String)
    func startTimer()
    func stopTimer()
    func emptyOtpCheck(otp: String)
}

protocol OTPDataStore {
    var number: String? { get set }
    var isNewUser: Bool? { get set }
    var isFromForgot: Bool? { get set }
    var isFromAccountClose: Bool? { get set }
}

class OTPInteractor: OTPBusinessLogic, OTPDataStore {
    var presenter: OTPPresentationLogic?
    var worker: OtpWorker?
    var number: String?
    var isFromForgot: Bool?
    var isFromAccountClose: Bool?
    var isNewUser: Bool?
    
    // MARK: Get Mobile Number
    func getMobileNumber() {
        let otpUIData = OTPUIData(number: self.number, isFromForgot: self.isFromForgot, isFromAccountClose: self.isFromAccountClose)
        self.presenter?.sendMobileNumber(otpUIData: otpUIData)
    }
    
    // MARK: Start Timer
    func startTimer() {
        worker?.callTimer(countDownVal: 45, completion: { updateCountDown in
            self.presenter?.updateCount(totalTime: updateCountDown)
        })
    }
    
    // MARK: Stop Timer
    func stopTimer() {
        worker?.endTimer()
    }
    
    // MARK: Get OTP
    func getOTP() {
        let requestDict = [
            "mobile": self.number
        ]

        worker?.callGetOTPApi(params: requestDict as Parameters, completion: { results, code in
            if let response = results, code == 200 {
                let response = OTP.OTPModel.Response(getOTPResponse: response)
                self.presenter?.presentOTPResponse(response: response)
            }
        })
    }
    // MARK: Validate OTP
    func getValidateOTP(otp: String) {
        var requestDict = [
            "mobileNumber": self.number ?? "",
            "otp": otp
        ]
        if isNewUser ?? false {
            requestDict.updateValue("true", forKey: "bypass")
        }

        worker?.callValidateOTPApi(params: requestDict as Parameters, completion: { results, code in
            if let response = results, code == 200 {
                let response = OTP.OTPModel.Response(validateOTPResponse: response)
                self.presenter?.presentValidateOTPResponse(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: Validate Empty OTP
    func emptyOtpCheck(otp: String) {
        if otp.contains("$") || otp.count < 6 {
            presenter?.presentEmptyOtpResponse(isValid: false)
        } else {
            presenter?.presentEmptyOtpResponse(isValid: true)
        }
    }
}
