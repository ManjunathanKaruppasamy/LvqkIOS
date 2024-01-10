//
//  InitialModels.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import ObjectMapper

enum DeviceValidatorResult: CustomStringConvertible {
    case deviceJailBroken
    case vpnConnection
    case success
    
    var description: String {
        switch self {
        case .deviceJailBroken:
            return "Application cannot be installed in this device"
        case .vpnConnection:
            return "VPN detected. Please turn VPN off to proceed"
        case .success:
            return ""
        }
    }
    
}

// swiftlint:disable nesting
enum Initial {
  // MARK: Use cases
  
  enum Fetchkits {
    struct Request {
    }
    struct Response {
        var pairPublicKeyResponse: PairPublicKeyResponse?
        var response: CheckRegisterModel?
    }
    struct ViewModel {
        var pairPublicKeyResponse: PairPublicKeyResponse?
        var viewModel: CheckRegisterModel?
    }
  }
}

struct PairPublicKeyResponse: Mappable {
    var result: PublicKeyResult?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        result <- map["result"]
    }

}

struct PublicKeyResult: Mappable {
    var status: String?
    var sharedSecret: String?
    var serverPublicKey: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        sharedSecret <- map["sharedSecret"]
        serverPublicKey <- map["serverPublicKey"]
    }

}
