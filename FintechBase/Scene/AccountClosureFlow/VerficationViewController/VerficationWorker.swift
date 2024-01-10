//
//  VerficationWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class VerficationWorker {
    
    // MARK: Fetch Account Closure api
    func callfetchAccountClosureApi(params: Parameters?, completion: @escaping  (_ results: GetAccountClosureResponseModel?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.accountClosure, parameter: params) { (result: GetAccountClosureResponseModel?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
