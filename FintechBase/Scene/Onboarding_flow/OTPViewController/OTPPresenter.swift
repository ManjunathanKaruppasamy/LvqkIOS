//
//  OTPPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol OTPPresentationLogic {
    func presentOTPResponse(response: OTP.OTPModel.Response)
    func presentValidateOTPResponse(response: OTP.OTPModel.Response)
    func sendMobileNumber(otpUIData: OTPUIData)
    func updateCount(totalTime: String)
    func presentEmptyOtpResponse(isValid: Bool)
}

class OTPPresenter: OTPPresentationLogic {
    weak var viewController: OTPDisplayLogic?
    
    // MARK: Send Mobile Number
    func sendMobileNumber(otpUIData: OTPUIData) {
        
        self.viewController?.presentMobileNumber(otpUIData: otpUIData)
    }
    
    // MARK: Update Timer Count
    func updateCount(totalTime: String) {
        self.viewController?.updateCount(totalTime: totalTime)
    }
    // MARK: Present OTP Response
    func presentOTPResponse(response: OTP.OTPModel.Response) {
        let viewModel = OTP.OTPModel.ViewModel(getOTPViewModel: response.getOTPResponse)
        self.viewController?.displayOTPResponse(viewModel: viewModel)
    }
    
    // MARK: Present Validate OTP Response
    func presentValidateOTPResponse(response: OTP.OTPModel.Response) {
        let viewModel = OTP.OTPModel.ViewModel(validateOTPViewModel: response.validateOTPResponse)
        self.viewController?.displayValidateOTP(viewModel: viewModel)
    }
    
    // MARK: Present Empty OTP Response
    func presentEmptyOtpResponse(isValid: Bool) {
        viewController?.displayEmptyOtpResponse(isValid: isValid)
    }
}
