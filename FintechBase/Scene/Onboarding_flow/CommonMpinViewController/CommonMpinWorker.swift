//
//  CommonMpinWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class CommonMpinWorker {
    
    // MARK: - Timer WorkLogic
    
    private var countDownTimer: Timer?
    private var countDown: Int = 0
    private var timerCompletion: ((_ updateCount: String) -> Void)?
    
    func callTimer(countDownVal: Int, completion: @escaping (_ updateCount: String) -> Void) {
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
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension CommonMpinWorker {
    
    /* Call Mpin API */
    func callMPINApi(params: Parameters?, completion: @escaping  (_ results: MPINResponseData?,
                                                                     _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.customerUpdate, parameter: params) { (result: MPINResponseData?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    /* Call Login API */
    func callLoginMPIN(params: Parameters?, completion: @escaping  (_ results: LoginMpinResponseData?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.login, parameter: params) { (result: LoginMpinResponseData?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: Fetch Customer Details
    func callFetchCustomer(params: Parameters?, completion: @escaping (_ results: AccountDetailsRespone?,
                                                                        _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchCustomer, parameter: params) { (result: AccountDetailsRespone?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
