//
//  AddVehicleWorker.swift
//  FintechBase
//
//  Created by Sravani Madala on 07/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

class AddVehicleWorker {
    func doSomeWork() {
    }
    
    // MARK: Fetch tag vehicle classes list
    func fetchVehicleClassesList(params: Parameters?, completion: @escaping  (_ results: FastTagVehicleClass?, _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fetchTagClass, parameter: params) { (result: FastTagVehicleClass?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
