//
//  DashboardModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 08/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum Dashboard {
  // MARK: Use cases
  
  enum DashboardModel {
    struct Request {
    }
    struct Response {
        var vehicleListResponse: VehicleListResponse?
        var getBalanceResponse: GetBalanceResponse?
        var getCardResponse: GetCardResponse?
//        var getMultiCardResponse: GetMultiCardResponse?
        var getBannerListResponse: GetBannerApiResponseModel?
        var upiListData: [UPIListData]?
    }
    struct ViewModel {
        var vehicleListResultArray: [VehicleListResultArray]?
        var getBalanceViewModel: GetBalanceResponse?
        var getCardViewModel: GetCardResponse?
//        var getMultiCardResponse: GetMultiCardResponse?
        var getBannerListViewModel: GetBannerApiResponseModel?
        var upiListData: [UPIListData]?
    }
  }
}

struct UPIListData {
    var title: String
    var image: String
}

struct GetBalanceResponse: Mappable {
    var status: String?
    var result: [GetBalanceResult]?
    var exception: Exception?
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

struct GetBalanceResult: Mappable {
    var entityId: String?
    var productId: String?
    var balance: String?
    var lienBalance: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        entityId <- map["entityId"]
        productId <- map["productId"]
        balance <- map["balance"]
        lienBalance <- map["lienBalance"]
    }

}

struct GetCardResponse: Mappable {
    var status: String?
    var result: [GetCardResultArray]?
    var exception: Exception?
    var pagination: Pagination?
    var dob: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
        dob <- map["dob"]
    }

}

struct GetCardResultArray: Mappable {
    var cardNumber: String?
    var kitNumber: String?
    var expiryDate: String?
    var cardStatus: String?
    var cardType: String?
    var networkType: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        cardNumber <- map["cardNumber"]
        kitNumber <- map["kitNumber"]
        expiryDate <- map["expiryDate"]
        cardStatus <- map["cardStatus"]
        cardType <- map["cardType"]
        networkType <- map["networkType"]
    }

}

/*Response Structure Model*/
struct M2PResponseModel: Mappable {
    var result: Bool?
    var exception: M2PExceptionModel?
    var pagination: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
    }
}

/*Exception Response Structure Model*/
struct M2PExceptionModel: Mappable {
    var cause: String?
    var detailMessage: String?
    var shortMessage: String?
    var errorCode: String?
    var localizedMessage: String?
    var message: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        cause <- map["cause"]
        detailMessage <- map["detailMessage"]
        shortMessage <- map["shortMessage"]
        errorCode <- map["errorCode"]
        message <- map["message"]
        localizedMessage <- map["localizedMessage"]
    }
}

/*Bit URL Detials*/
struct M2PBitUrlResponseModel: Mappable {
    var result: M2PBitURLResult?
    var exception: M2PExceptionModel?
    var pagination: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
    }
}

struct M2PBitURLResult: Mappable {
    var secureUrl: String?
    var publicKey: String?
    var pek: String?
    var url: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        secureUrl <- map["secureUrl"]
        publicKey <- map["publicKey"]
        pek <- map["pek"]
        url <- map["url"]
    }
}

// MARK: Get Banner Api Response
struct GetBannerApiResponseModel: Mappable {
    var status: String?
    var result: [GetBannerResult]?
    var exception: Exception?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        result <- map["result"]
        exception <- map["exception"]
    }
}

struct GetBannerResult: Mappable {
    var id: String?
    var name: String?
    var description: String?
    var image: String?
    var vText: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        description <- map["description"]
        image <- map["image"]
        vText <- map["__v"]
    }
}

// MARK: Multi Card Model
//struct GetMultiCardResponse: Mappable {
//    var status: String?
//    var statusCode: Int?
//    var result: [MultiCardResultArray]?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        status <- map["status"]
//        statusCode <- map["statusCode"]
//        result <- map["result"]
//    }
//
//}

//struct MultiCardResultArray: Mappable {
//    var card: [MultiCardArray]?
//    var balance: [MultiCardBalance]?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        card <- map["card"]
//        balance <- map["balance"]
//    }
//
//}

//struct MultiCardArray: Mappable {
//    var cardNumber: String?
//    var kitNumber: String?
//    var expiryDate: String?
//    var cardStatus: String?
//    var cardType: String?
//    var networkType: String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        cardNumber <- map["cardNumber"]
//        kitNumber <- map["kitNumber"]
//        expiryDate <- map["expiryDate"]
//        cardStatus <- map["cardStatus"]
//        cardType <- map["cardType"]
//        networkType <- map["networkType"]
//    }
//
//}

//struct MultiCardBalance: Mappable {
//    var entityId: String?
//    var productId: String?
//    var balance: String?
//    var lienBalance: String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        entityId <- map["entityId"]
//        productId <- map["productId"]
//        balance <- map["balance"]
//        lienBalance <- map["lienBalance"]
//    }
//
//}
