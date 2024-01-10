//
//  TrackIssueWorker.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 07/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper
@_implementationOnly import Alamofire

class TrackIssueWorker {
    // MARK: Update Mpin Api
    func callDisputeEntityApi(params: Parameters?, completion: @escaping  (_ results: DisputeEntityModel?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.disputeEntity, parameter: params) { (result: DisputeEntityModel?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
