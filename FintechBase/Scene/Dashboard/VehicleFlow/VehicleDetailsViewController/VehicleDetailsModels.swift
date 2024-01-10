//
//  VehicleDetailsModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 15/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum VehicleDetails {
  // MARK: Use cases
  
  enum VehicleDetailsModel {
    struct Request {
    }
    struct Response {
        var vehicleDetailsArr: [VehicleDetailsData]?
    }
    struct ViewModel {
        var vehicleDetailsDataArr: [VehicleDetailsData]?
    }
  }
}

struct VehicleDetailsData {
    var title: String?
    var description: String?
}

struct VehicleTransactionModel: Mappable {
    var status: String?
    var result: [VehicleTransactionArrayItem]?
    var exception: String?
    var pagination: Pagination?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
    }
}

struct VehicleTransactionArrayItem: Mappable {
    var amount: String?
    var balance: Double?
    var transactionType: String?
    var type: String?
    var time: Int?
    var txRef: Double?
    var businessId: String?
    var beneficiaryName: String?
    var beneficiaryId: String?
    var description: String?
    var otherPartyName: String?
    var otherPartyId: String?
    var txnOrigin: String?
    var transactionStatus: String?
    var yourWallet: String?
    var beneficiaryWallet: String?
    var externalTransactionId: String?
    var bankTid: String?
    var convertedAmount: Double?
    var kitNo: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        amount <- map["amount"]
        balance <- map["balance"]
        transactionType <- map["transactionType"]
        type <- map["type"]
        time <- map["time"]
        txRef <- map["txRef"]
        businessId <- map["businessId"]
        beneficiaryName <- map["beneficiaryName"]
        beneficiaryId <- map["beneficiaryId"]
        description <- map["description"]
        otherPartyName <- map["otherPartyName"]
        otherPartyId <- map["otherPartyId"]
        txnOrigin <- map["txnOrigin"]
        transactionStatus <- map["transactionStatus"]
        yourWallet <- map["yourWallet"]
        beneficiaryWallet <- map["beneficiaryWallet"]
        externalTransactionId <- map["externalTransactionId"]
        bankTid <- map["bankTid"]
        convertedAmount <- map["convertedAmount"]
        kitNo <- map["kitNo"]
    }
}
