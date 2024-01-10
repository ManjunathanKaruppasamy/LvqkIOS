//
//  MobileNumberWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class MobileNumberWorker {
    /* Check Register User API */
    func callRegisterCustomer(params: Parameters?, completion: @escaping  (_ results: CheckRegisterModel?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.checkRegisterCustomer, parameter: params) { (result: CheckRegisterModel?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
