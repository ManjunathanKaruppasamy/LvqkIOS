//
//  FitmentCertificateModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum FitmentCertificate {
  // MARK: Use cases
  enum FitmentCertificateModel {
    struct Request {
        var fitmentCertificateData: FitmentCertificateData?
    }
    struct Response {
        var fitmentCertificateData: FitmentCertificateResponse?
        var sendEmail: Bool?
    }
    struct ViewModel {
        var fitmentCertificateData: FitmentCertificateResponse?
        var sendEmail: Bool?
    }
  }
}

struct FitmentCertificateData {
    var vehicleNumber: String
    var url: String
}

struct FitmentCertificateResponse: Mappable {
    var status: String?
    var result: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        result <- map["result"]
    }
}
