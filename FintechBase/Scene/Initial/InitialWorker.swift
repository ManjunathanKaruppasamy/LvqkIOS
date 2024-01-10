//
//  InitialWorker.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class InitialWorker {
    // MARK: Get Pair Public Key
    func fetchPairPublicKey(params: Parameters?, completion: @escaping (_ results: PairPublicKeyResponse?,
                                                                        _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.pairPublicKey, parameter: params, withEncryption: false) { (result: PairPublicKeyResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    /* Call Register API */
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
