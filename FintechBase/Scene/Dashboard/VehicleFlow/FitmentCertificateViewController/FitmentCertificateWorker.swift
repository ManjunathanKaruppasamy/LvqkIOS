//
//  FitmentCertificateWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class FitmentCertificateWorker {
    
    // MARK: Get Vehile Transaction Api
    func callfitmentCerticateApi(params: Parameters?, completion: @escaping  (_ results: FitmentCertificateResponse?,
                                               _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.fitmentCertificate, parameter: params) { (result: FitmentCertificateResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
