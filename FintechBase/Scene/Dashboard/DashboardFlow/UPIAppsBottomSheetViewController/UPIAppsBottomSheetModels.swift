//
//  UPIAppsBottomSheetModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/06/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum UPIAppsBottomSheet {
  // MARK: Use cases
  
  enum UPIAppsBottomSheetModel {
    struct Request {
    }
    struct Response {
        var getReferenceIdResponse: GetReferenceIdResponse?
        var fetchTransactionResponse: FetchTransactionResponse?
    }
    struct ViewModel {
        var getReferenceIdResponse: GetReferenceIdResponse?
        var fetchTransactionResponse: FetchTransactionResponse?
    }
  }
}

struct UPIAppsData {
    var name: String?
    var urlScheme: String?
    var pushURL: String?
}

struct GetReferenceIdResponse: Mappable {
    var status: String?
    var exception: Exception?
    var seqNo: String?
    var callbackRef: String?
    var message: String?
    var pagination: String?
    var result: GetReferenceIdResult?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        exception <- map["exception"]
        seqNo <- map["seqNo"]
        callbackRef <- map["callbackRef"]
        message <- map["message"]
        pagination <- map["pagination"]
        result <- map["result"]
    }

}

struct GetReferenceIdResult: Mappable {
    var result: String?
    var txnId: String?
    var refId: String?
    var urn: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        result <- map["result"]
        txnId <- map["txnId"]
        refId <- map["refId"]
        urn <- map["urn"]
    }

}

struct FetchTransactionResponse : Mappable {
    var status : String?
    var exception : Exception?
    var seqNo : String?
    var callbackRef : String?
    var message : String?
    var pagination : String?
    var result : [FetchTransactioResult]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        exception <- map["exception"]
        seqNo <- map["seqNo"]
        callbackRef <- map["callbackRef"]
        message <- map["message"]
        pagination <- map["pagination"]
        result <- map["result"]
    }

}

struct FetchTransactioResult : Mappable {
    var txnId : String?
    var txnNature : String?
    var rrn : String?
    var amount : String?
    var txnType : String?
    var txnSubType : String?
    var status : String?
    var createdDate : Int?
    var payeeName : String?
    var payeeAddr : String?
    var payeeMaskedAccNumber : String?
    var payeeBank : String?
    var payeeRespCode : String?
    var payeeReversalRespCode : String?
    var payerAddr : String?
    var payerIfsc : String?
    var payeeIfsc : String?
    var payerAcType : String?
    var payeeAcType : String?
    var payerName : String?
    var payerMaskedAccNumber : String?
    var payerBank : String?
    var payerRespCode : String?
    var payerReversalRespCode : String?
    var remarks : String?
    var lastEvent : String?
    var collectStatus : String?
    var description : String?
    var category : String?
    var checkTxnCount : Int?
    var isComplaintRaised : Bool?
    var dispute : FetchTransactioDispute?
    var expiryTime : String?
    var refUrl : String?
    var errCode : String?
    var errDescription : String?
    var initiationMode : String?
    var purpose : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        txnId <- map["txnId"]
        txnNature <- map["txnNature"]
        rrn <- map["rrn"]
        amount <- map["amount"]
        txnType <- map["txnType"]
        txnSubType <- map["txnSubType"]
        status <- map["status"]
        createdDate <- map["createdDate"]
        payeeName <- map["payeeName"]
        payeeAddr <- map["payeeAddr"]
        payeeMaskedAccNumber <- map["payeeMaskedAccNumber"]
        payeeBank <- map["payeeBank"]
        payeeRespCode <- map["payeeRespCode"]
        payeeReversalRespCode <- map["payeeReversalRespCode"]
        payerAddr <- map["payerAddr"]
        payerIfsc <- map["payerIfsc"]
        payeeIfsc <- map["payeeIfsc"]
        payerAcType <- map["payerAcType"]
        payeeAcType <- map["payeeAcType"]
        payerName <- map["payerName"]
        payerMaskedAccNumber <- map["payerMaskedAccNumber"]
        payerBank <- map["payerBank"]
        payerRespCode <- map["payerRespCode"]
        payerReversalRespCode <- map["payerReversalRespCode"]
        remarks <- map["remarks"]
        lastEvent <- map["lastEvent"]
        collectStatus <- map["collectStatus"]
        description <- map["description"]
        category <- map["category"]
        checkTxnCount <- map["checkTxnCount"]
        isComplaintRaised <- map["isComplaintRaised"]
        dispute <- map["dispute"]
        expiryTime <- map["expiryTime"]
        refUrl <- map["refUrl"]
        errCode <- map["errCode"]
        errDescription <- map["errDescription"]
        initiationMode <- map["initiationMode"]
        purpose <- map["purpose"]
    }

}

struct FetchTransactioDispute : Mappable {
    var createdDate : Int?
    var modifiedDate : Int?
    var createdBy : String?
    var modifiedBy : String?
    var deleted : Bool?
    var orgTxnId : String?
    var orgRrn : String?
    var description : String?
    var profileId : String?
    var crn : String?
    var status : String?
    var statusDescription : String?
    var statusUpdated : Bool?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        createdDate <- map["createdDate"]
        modifiedDate <- map["modifiedDate"]
        createdBy <- map["createdBy"]
        modifiedBy <- map["modifiedBy"]
        deleted <- map["deleted"]
        orgTxnId <- map["orgTxnId"]
        orgRrn <- map["orgRrn"]
        description <- map["description"]
        profileId <- map["profileId"]
        crn <- map["crn"]
        status <- map["status"]
        statusDescription <- map["statusDescription"]
        statusUpdated <- map["statusUpdated"]
    }

}

