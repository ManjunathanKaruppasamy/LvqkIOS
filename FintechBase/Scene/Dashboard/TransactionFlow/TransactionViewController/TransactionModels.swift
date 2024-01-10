//
//  TransactionModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum Transaction {
  // MARK: Use cases
  
  enum TransactionModel {
    struct Request {
    }
    struct Response {
    }
    struct ViewModel {
    }
  }
}

struct TransactionHistoryModel: Mappable {
    var status: String?
    var result: [TransactionHistoryArrayItem]?
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

struct Pagination: Mappable {
    var isList: Bool?
    var pageSize: Int?
    var pageNo: Int?
    var totalPages: Int?
    var totalElements: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        isList <- map["isList"]
        pageSize <- map["pageSize"]
        pageNo <- map["pageNo"]
        totalPages <- map["totalPages"]
        totalElements <- map["totalElements"]
    }
}

struct TransactionHistoryArrayItem: Mappable {
    var transactionCounter: Double?
    var created: Int?
    var otherPartyId: String?
    var otherPartyName: String?
    var amount: Double?
    var description: String?
    var combinedTxnRef: Int?
    var transactionStatus: String?
    var transactionOrigin: String?
    var transactionType: String?
    var balance: Double?
    var externalTxnId: String?
    var networkType: String?
    var kitNo: String?
    var transactionEntityId: String?
    var type: String?
    var otherPartyBusiness: String?
    var cardType: String?
    var entityType: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        transactionCounter <- map["transactionCounter"]
        created <- map["created"]
        otherPartyId <- map["otherPartyId"]
        otherPartyName <- map["otherPartyName"]
        amount <- map["amount"]
        description <- map["description"]
        combinedTxnRef <- map["combinedTxnRef"]
        transactionStatus <- map["transactionStatus"]
        transactionOrigin <- map["transactionOrigin"]
        transactionType <- map["transactionType"]
        balance <- map["balance"]
        externalTxnId <- map["externalTxnId"]
        networkType <- map["networkType"]
        kitNo <- map["kitNo"]
        transactionEntityId <- map["transactionEntityId"]
        type <- map["type"]
        otherPartyBusiness <- map["otherPartyBusiness"]
        cardType <- map["cardType"]
        entityType <- map["entityType"]
    }

}
