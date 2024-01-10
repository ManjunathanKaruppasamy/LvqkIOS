//
//  UpdateEmailWorker.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

class UpdateEmailWorker {
    // MARK: Update Email Api
    func callUpdateEmailApi(params: Parameters?, completion: @escaping  (_ results: MPINResponseData?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.customerUpdate, parameter: params) { (result: MPINResponseData?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
