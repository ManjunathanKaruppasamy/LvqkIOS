//
//  VehicleDocumentModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import ObjectMapper

enum VehicleDocument {
    // MARK: Use cases
    
    enum Something {
        struct Request {
        }
        struct Response {
            var addVehicleResonce: AddVehicleResponce
        }
        struct ViewModel {
            var addVehicleResonce: AddVehicleResponce
        }
    }
}

struct InstructionDetailsModel {
    var title: String
    var instructionContentArray: [String]
    var isTickImageEnable: Bool
}

struct AddVehicleResponce: Mappable {
    var status: String?
    var error: String?
    var statusCode: Int?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        error <- map["error"]
        statusCode <- map["statusCode"]
    }
}

