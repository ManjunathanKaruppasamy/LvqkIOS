//
//  VehicleWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class VehicleWorker {
    // MARK: Fetch Vehicle List
    func callfetchVehicleListApi(params: Parameters?, completion: @escaping  (_ results: VehicleListResponse?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchVehicles, parameter: params) { (result: VehicleListResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: Change Tag Status
    func callChangeTagStatusApi(params: Parameters?, completion: @escaping  (_ results: ChangeTagResponse?, _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.changeTagStatus, parameter: params) { (result: ChangeTagResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
