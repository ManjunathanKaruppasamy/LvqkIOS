//
//  SettingsWorker.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper
@_implementationOnly import Alamofire

class SettingsWorker {
    /* Call Fetch Customer */
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
}
