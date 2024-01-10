//
//  ReasonsForClosureWorker.swift
//  FintechBase
//
//  Created by Sravani Madala on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class ReasonsForClosureWorker {
    // MARK: Fetch Closure Reasons
    func callfetchClosureReasons(params: Parameters?, completion: @escaping  (_ results: ClosureReasonsModel?,
                                                                          _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.getClosureReasons, parameter: params) { (result: ClosureReasonsModel?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
