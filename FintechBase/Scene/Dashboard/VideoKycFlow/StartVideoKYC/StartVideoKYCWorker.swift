//
//  StartVideoKYCWorker.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class StartVideoKYCWorker {
    /* Call FetchVKyc link API*/
    func callVKYCApi(params: Parameters?, completion: @escaping  (_ results: VKYCResponse?,
                                                                  _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchVkycLink, parameter: params) { (result: VKYCResponse?, error, code, headLessResponse) in
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
