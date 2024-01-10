//
//  VehicleModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum Vehicle {
  // MARK: Use cases
  
  enum VehicleModel {
    struct Request {
    }
    struct Response {
        var vehicleListResponse: VehicleListResponse?
        var changeTagStatusReponse: ChangeTagResponse?
    }
    struct ViewModel {
        var vehicleListResultArray: [VehicleListResultArray]?
        var changeTagStatusResilt: ChangeTagResponse?
    }
  }
}

enum VehicleStatus {
    case active
    case inActive
    case blocked
}

struct VehicleListResponse: Mappable {
    var status: String?
    var result: VehicleListResult?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        result <- map["result"]
    }

}

struct VehicleListResult: Mappable {
    var result: [VehicleListResultArray]?
    var exception: Exception?
    var pagination: Pagination?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
    }

}

struct VehicleListResultArray: Mappable {
    var firstName: String?
    var lastName: String?
    var address: String?
    var city: String?
    var state: String?
    var country: String?
    var pincode: Int?
    var contactNo: String?
    var specialDate: Int?
    var entityId: String?
    var businessId: String?
    var emailAddress: String?
    var entityType: String?
    var kitNo: String?
    var kitStatus: String?
    var registeredDate: String?
    var profileId: String?
    var serialNo: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        firstName <- map["firstName"]
        lastName <- map["lastName"]
        address <- map["address"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
        pincode <- map["pincode"]
        contactNo <- map["contactNo"]
        specialDate <- map["specialDate"]
        entityId <- map["entityId"]
        businessId <- map["businessId"]
        emailAddress <- map["emailAddress"]
        entityType <- map["entityType"]
        kitNo <- map["kitNo"]
        kitStatus <- map["kitStatus"]
        registeredDate <- map["registeredDate"]
        profileId <- map["profileId"]
        serialNo <- map["serialNo"]
    }

}

struct ChangeTagResponse: Mappable {
    var status: String?
    var statusCode: Int?
    var result: VehicleListResult?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        result <- map["result"]
        statusCode <- map["statusCode"]
    }
}
