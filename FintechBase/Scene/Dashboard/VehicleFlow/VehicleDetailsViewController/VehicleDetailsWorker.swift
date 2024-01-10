//
//  VehicleDetailsWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 15/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class VehicleDetailsWorker {
    // MARK: Get Vehile Transaction Api
    func callVehicleTransactionApi(params: Parameters?, completion: @escaping  (_ results: VehicleTransactionModel?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.vehicleTransactions, parameter: params) { (result: VehicleTransactionModel?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
