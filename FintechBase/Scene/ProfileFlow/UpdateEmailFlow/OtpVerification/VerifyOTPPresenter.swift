//
//  VerifyOTPPresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VerifyOTPPresentationLogic {
    func presentTimerCount(totalTime: String)
    func presentUIAttributes(flowEnum: ModuleFlowEnum)
    func presentGenerateOTPResponse(response: VerifyOTP.OTPModel.Response)
    func presentValidateOTPResponse(response: VerifyOTP.OTPModel.Response)
    func presentEmptyOtpResponse(isValid: Bool)
    func presentUpdateEmailApiResponse(response: MPINResponseData?)
}

class VerifyOTPPresenter: VerifyOTPPresentationLogic {
  weak var viewController: VerifyOTPDisplayLogic?
  
  // MARK: Present TimerCount
    func presentTimerCount(totalTime: String) {
        viewController?.displayTimerCount(timerCount: totalTime)
    }
    
    // MARK: Present UIAttributes
    func presentUIAttributes(flowEnum: ModuleFlowEnum) {
        viewController?.displayUIAttributes(flowEnum: flowEnum)
    }
    
    // MARK: Present OTP Response
    func presentGenerateOTPResponse(response: VerifyOTP.OTPModel.Response) {
        let viewModel = VerifyOTP.OTPModel.ViewModel(getOTPViewModel: response.getOTPResponse)
        self.viewController?.displayGenerateOTPResponse(viewModel: viewModel)
    }
    
    // MARK: Present Validate OTP Response
    func presentValidateOTPResponse(response: VerifyOTP.OTPModel.Response) {
        let viewModel = VerifyOTP.OTPModel.ViewModel(validateOTPViewModel: response.validateOTPResponse)
        self.viewController?.displayValidateOTP(viewModel: viewModel)
    }
    
    /* Present EmptyOtp Response */
    func presentEmptyOtpResponse(isValid: Bool) {
        viewController?.displayEmptyOtpResponse(isValid: isValid)
    }
    
    /* Present UpdateEmailApi Response*/
    func presentUpdateEmailApiResponse(response: MPINResponseData?) {
        viewController?.displayUpdateEmailResponse(response: response)
    }
}
