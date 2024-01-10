//
//  ForgotMPINWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 03/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class ForgotMPINWorker {
    /* Call Forgot Mpin API */
    func callForgotMPIN(params: Parameters?, completion: @escaping  (_ results: ForgotMPINResponse?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.forgotMpin, parameter: params) { (result: ForgotMPINResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
