//
//  TransactionDetailsModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 21/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

enum TransactionDetails {
  // MARK: Use cases
  
  enum TransactionDetailsModel {
    struct Request {
        var transactionRequest: String?
    }
    struct Response {
        var transactionDetailList: [TransactionDetailModel]?
        var transactionModel: TransactionModel?
    }
    struct ViewModel {
        var transactionDetailList: [TransactionDetailModel]?
        var transactionModel: TransactionModel?
    }
  }
}

struct TransactionDetailModel {
    var name: String?
    var value: String
}

struct TransactionModel: Mappable {
    var status: String?
    var result: TransactionResult?
    var exception: String?
    var pagination: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        result <- map["result"]
        exception <- map["exception"]
        pagination <- map["pagination"]
    }
    
}

struct TransactionResult: Mappable {
    var transaction: TransactionHistory?
    var balance: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        transaction <- map["transaction"]
        balance <- map["balance"]
    }
    
}

struct TransactionHistory: Mappable {
    var amount: String?
    var balance: Int?
    var transactionType: String?
    var type: String?
    var time: Int?
    var txRef: Int?
    var businessId: String?
    var beneficiaryName: String?
    var beneficiaryType: String?
    var beneficiaryId: String?
    var description: String?
    var otherPartyName: String?
    var otherPartyId: String?
    var txnOrigin: String?
    var transactionStatus: String?
    var status: String?
    var yourWallet: String?
    var beneficiaryWallet: String?
    var externalTransactionId: String?
    var retrivalReferenceNo: String?
    var authCode: String?
    var billRefNo: String?
    var bankTid: String?
    var acquirerId: String?
    var mcc: String?
    var convertedAmount: Int?
    var networkType: String?
    var limitCurrencyCode: String?
    var kitNo: String?
    var sorTxnId: String?
    var transactionCurrencyCode: String?
    var fxConvDetails: String?
    var convDetails: String?
    var disputedDto: String?
    var disputeRef: String?
    var accountNo: String?
    var serialNo: String?
    var cardType: String?

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
        beneficiaryType <- map["beneficiaryType"]
        beneficiaryId <- map["beneficiaryId"]
        description <- map["description"]
        otherPartyName <- map["otherPartyName"]
        otherPartyId <- map["otherPartyId"]
        txnOrigin <- map["txnOrigin"]
        transactionStatus <- map["transactionStatus"]
        status <- map["status"]
        yourWallet <- map["yourWallet"]
        beneficiaryWallet <- map["beneficiaryWallet"]
        externalTransactionId <- map["externalTransactionId"]
        retrivalReferenceNo <- map["retrivalReferenceNo"]
        authCode <- map["authCode"]
        billRefNo <- map["billRefNo"]
        bankTid <- map["bankTid"]
        acquirerId <- map["acquirerId"]
        mcc <- map["mcc"]
        convertedAmount <- map["convertedAmount"]
        networkType <- map["networkType"]
        limitCurrencyCode <- map["limitCurrencyCode"]
        kitNo <- map["kitNo"]
        sorTxnId <- map["sorTxnId"]
        transactionCurrencyCode <- map["transactionCurrencyCode"]
        fxConvDetails <- map["fxConvDetails"]
        convDetails <- map["convDetails"]
        disputedDto <- map["disputedDto"]
        disputeRef <- map["disputeRef"]
        accountNo <- map["accountNo"]
        serialNo <- map["serialNo"]
        cardType <- map["cardType"]
    }

}
