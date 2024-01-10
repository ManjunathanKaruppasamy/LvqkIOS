//
//  UPIAppsBottomSheetWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/06/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class UPIAppsBottomSheetWorker {
    /* Call PayU Api */
    func callGetReferenceIdApi(params: Parameters?, completion: @escaping  (_ results: GetReferenceIdResponse?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.getReferenceId, parameter: params) { (result: GetReferenceIdResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    func callFetchTransactionByTxnIdApi(params: Parameters?, completion: @escaping  (_ results: FetchTransactionResponse?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchTransactionByTxnId, parameter: params) { (result: FetchTransactionResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}

