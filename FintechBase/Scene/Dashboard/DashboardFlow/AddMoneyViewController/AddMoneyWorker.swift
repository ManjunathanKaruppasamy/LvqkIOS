//
//  AddMoneyWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class AddMoneyWorker {
    /* Call PayU Api */
    func callPayUApi(params: Parameters?, completion: @escaping  (_ results: PayUResponse?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchPgUrl, parameter: params) { (result: PayUResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
//    /* Call Fetch Balance Api */
    func callfetchBalanceApi(params: Parameters?, completion: @escaping  (_ results: GetBalanceResponse?,
                                                                          _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.getBalance, parameter: params) { (result: GetBalanceResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
