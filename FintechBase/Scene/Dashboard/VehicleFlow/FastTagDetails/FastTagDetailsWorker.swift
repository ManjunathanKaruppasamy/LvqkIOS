//
//  FastTagDetailsWorker.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

class FastTagDetailsWorker {
    // MARK: Fetch tag vehicle classes list
    func fetchFastTagFee(params: Parameters?, completion: @escaping  (_ results: FastTagFeeData?, _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchTagFee, parameter: params) { (result: FastTagFeeData?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    /* Call PayU Api */
    func callPayUApi(params: Parameters?, completion: @escaping  (_ results: PayUResponse?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchPgUrl, parameter: params) { (result: PayUResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: fetch add vehicle data
    func callFetchAddVehicle(params: Parameters?, completion: @escaping  (_ results: AddVehicleResponce?, _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.addVehicle, parameter: params) { (result: AddVehicleResponce?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
