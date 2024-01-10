//
//  VerifyOTPWorker.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

class VerifyOTPWorker {
      
    var apiManager = APIManager.shared()
    
    // MARK: - Timer WorkLogic
    private var countDownTimer: Timer?
    private var countDown: Int = 0
    private var timerCompletion: ((_ updateCountDown: String) -> Void)?
    
    func callTimer(countDownVal: Int, completion: @escaping (_ updateCountDown: String) -> Void) {
        self.countDown = countDownVal
        self.timerCompletion = completion
        self.countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        self.countDown = (self.countDown > -1) ? self.countDown : 0
        self.timerCompletion?(timeFormatted(countDown))
        if countDown != 0 {
            countDown = (countDown) - 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countDownTimer?.invalidate()
        countDownTimer = nil
        timerCompletion = nil
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: Get OTP Api
    func callGetOTPApi(params: Parameters?, completion: @escaping  (_ results: GetOTPResponseData?,
                                               _ code: Int?) -> Void) {
        self.apiManager.call(type: EndpointItem.generateOtp, parameter: params) { (result: GetOTPResponseData?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: Validate OTP Api
    func callValidateOTPApi(params: Parameters?, completion: @escaping  (_ results: ValidateOTPResponseData?,
                                               _ code: Int?) -> Void) {
        self.apiManager.call(type: EndpointItem.validateOtp, parameter: params) { (result: ValidateOTPResponseData?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: Update Email Api
    func callUpdateEmailApi(params: Parameters?, completion: @escaping  (_ results: MPINResponseData?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.customerUpdate, parameter: params) { (result: MPINResponseData?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
