//
//  AccountDetailsWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class AccountDetailsWorker {
    /* Call Fetch Customer API */
    func callFetchCustomer(params: Parameters?, completion: @escaping  (_ results: AccountDetailsRespone?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchCustomer, parameter: params) { (result: AccountDetailsRespone?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    /* Call Register User API */
    func callRegisterUSer(params: Parameters?, completion: @escaping  (_ results: RegisterUserResponseData?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.registerCustomer, parameter: params) { (result: RegisterUserResponseData?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
