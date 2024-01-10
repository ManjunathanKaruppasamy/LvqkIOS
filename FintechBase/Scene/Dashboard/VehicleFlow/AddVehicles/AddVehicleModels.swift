//
//  AddVehicleModels.swift
//  FintechBase
//
//  Created by Sravani Madala on 07/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum AddVehicle {
    // MARK: Use cases
    
    enum VehicleFastTagModel {
        struct Request {
        }
        struct Response {
            let fastTagVehicleClass: FastTagVehicleClass?
        }
        struct ViewModel {
            let getFastTagVehicleModel: FastTagVehicleClass?
        }
    }
}

class AddVehicleData {
    static var instance: AddVehicleData?

    class var sharedInstace: AddVehicleData {
        if instance == nil {
            instance = AddVehicleData()
        }
        return instance!
    }
    
//    static var sharedInstance: AddVehicleData?
    
    var vehicleNumber: String = ""
    var vehicleClass: String = ""
    var isCommercial: Bool = false
    var insurance: String = ""
    var applicantPhoto: String = ""
    var isChasis: Bool = false
    var rcFront: String = ""
    var rcBack: String = ""
    var isApplicantExist: Bool = false

    func destroy() {
        AddVehicleData.instance = nil
    }
    
    init() {
        self.vehicleNumber = ""
        self.vehicleClass = ""
        self.isCommercial = false
        self.insurance = ""
        self.applicantPhoto = ""
        self.isChasis = false
        self.rcFront = ""
        self.rcBack = ""
        self.isApplicantExist = false
    }
    
    deinit {
        print("Class Deinitied")
    }
}

struct FastTagVehicleClass: Mappable {
    var status: String?
    var result: [FastTagResultList]?
    var statusCode: Int?

    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        result <- map["result"]
        statusCode <- map["statusCode"]
    }
}

struct FastTagResultList: Mappable {
    var id: String?
    var tagClass: String?
    var image: String?
    var title: String?

    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        id <- map["_id"]
        tagClass <- map["tagClass"]
        image <- map["image"]
        title <- map["title"]
    }
}
