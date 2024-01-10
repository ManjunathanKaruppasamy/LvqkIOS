//
//  TransactionDetailsWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 21/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class TransactionDetailsWorker {
    func callTransactionDetails(params: Parameters?, completion: @escaping  (_ results: TransactionModel?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.detailTransaction, parameter: params) { (result: TransactionModel?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
