//
//  NegativeBalanceWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class NegativeBalanceWorker {
//    var apiManager: APIHandler
//    init(apiManager: APIHandler) {
//        self.apiManager = apiManager
//    }
//    
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
}
