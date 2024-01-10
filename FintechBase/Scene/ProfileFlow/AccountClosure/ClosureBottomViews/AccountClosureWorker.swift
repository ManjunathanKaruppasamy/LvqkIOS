//
//  AccountClosureWorker.swift
//  FintechBase
//
//  Created by Sravani Madala on 26/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class AccountClosureWorker {
    // MARK: Fetch Request Call Back Api
    func fetchRequestCallBackApi(params: Parameters?, completion: @escaping  (_ results: RequestCallBackResponse?,
                                                                          _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.requestCallBack, parameter: params) { (result: RequestCallBackResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
