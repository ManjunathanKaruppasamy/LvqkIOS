//
//  FastTagDetailsModels.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum FastTagDetails {
    // MARK: Use cases
    
    enum FastTagFeeModel {
        struct Request {
        }
        struct Response {
            let fastTagFee: FastTagFeeData?
        }
        struct ViewModel {
            let getfastTagFeeModel: FastTagFeeData?
        }
    }
}

struct FastTagFeeData: Mappable {
    var status: String?
    var result: FastTagFeeResult?

    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        result <- map["result"]
    }
}

struct FastTagFeeResult: Mappable {
    var tagFee: Double?
    var gst: Double?
    var fastTagBalance: Double?
    var total: Double?

    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        tagFee <- map["tagFee"]
        gst <- map["gst 5%"]
        fastTagBalance <- map["fastTagBalance"]
        total <- map["total"]
    }
}
