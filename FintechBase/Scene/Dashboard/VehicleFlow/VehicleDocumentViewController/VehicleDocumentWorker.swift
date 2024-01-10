//
//  VehicleDocumentWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

class VehicleDocumentWorker {
    
    func doSomeWork() {
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
