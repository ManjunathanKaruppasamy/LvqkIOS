//
//  EndPointItem.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//

import Foundation
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

enum EndpointItem {
    // MARK: User actions
    case checkRegisterCustomer
    case forgotMpin
    case generateOtp
    case validateOtp
    case customerUpdate
    case fetchCustomer
    case login
    case getBalance
    case fetchVehicles
    case getCardList
    case fetchPgUrl
    case updateUser
    case fetchTransactions
    case vehicleTransactions
    case disputeEntity
    case detailTransaction
    case replaceFastTag
    case getTags
    case fitmentCertificate
    case getBanners
    case fetchVkycLink
    case pairPublicKey
    case pairSDKPublicKey
    case generateBitUrl
    case getClosureReasons
    case accountClosure
    case addVehicle
    case fetchTagClass
    case fetchTagFee
    case changeTagStatus
    case requestCallBack
    case registerCustomer
    case fetchAllCards
    case getReferenceId
    case fetchTransactionByTxnId
}

// MARK: - Extensions
// MARK: - EndPointType
extension EndpointItem: EndPointType {
    
    // MARK: - Vars & Lets

    var baseURL: String {
        var urlDict: NSDictionary?
        var url: String = ""
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            urlDict = NSDictionary(contentsOfFile: path)
//            print(urlDict?.value(forKey: "API_BASE_URL_ENDPOINT") ?? "default")
            url = urlDict?.value(forKey: "API_BASE_URL_ENDPOINT") as? String ?? ""
            return url
        }
        return url
    }
    
    var version: String {
        "/v0_1"
    }
    
    var encryptionPath: String {
        if encryptionEnabled == "YES" {
            return "enc/lqfleet/"
        }
        return "lqfleet/"
    }
    
    var path: String {
        switch self {
        case .checkRegisterCustomer:
            return "\(encryptionPath)customer/registered"
        case .forgotMpin:
            return "\(encryptionPath)customer/forgotMpin"
        case .generateOtp:
            return "\(encryptionPath)customer/generateOtp"
        case .validateOtp:
            return "\(encryptionPath)customer/validateOtp"
        case .customerUpdate:
            return "\(encryptionPath)customer/update"
        case .fetchCustomer:
            return "\(encryptionPath)customer/detailsByMobile"
        case .login:
            return "\(encryptionPath)customer/login"
        case .getBalance:
            return "\(encryptionPath)customer/getBalance"
        case .fetchVehicles:
            return "\(encryptionPath)vehicle/fetchVehiclesByParent"
        case .getCardList:
            return "\(encryptionPath)customer/getCardList"
        case .fetchPgUrl:
            return "\(encryptionPath)customer/fetchPgUrl"
        case .updateUser:
            return "\(encryptionPath)user/update"
        case .fetchTransactions:
            return "\(encryptionPath)customer/fetchTransactions"
        case .vehicleTransactions:
            return "\(encryptionPath)vehicle/fetchTransactions"
        case .disputeEntity:
            return "\(encryptionPath)dispute/entity"
        case .detailTransaction:
            return "\(encryptionPath)customer/getTransactionDetail"
        case .getTags:
            return "\(encryptionPath)tag/getReplaceTagReasons"
        case .replaceFastTag:
            return "\(encryptionPath)tag/replace"
        case .fitmentCertificate:
            return "\(encryptionPath)tag/emailCertificate"
        case .getBanners:
            return "\(encryptionPath)banner/get"
        case .fetchVkycLink:
            return "\(encryptionPath)customer/fetchVkycLink"
        case .pairPublicKey:
            return "lqfleet/pairPublicKey"
        case .pairSDKPublicKey:
            return "\(encryptionPath)customer/pairPublicKey"
        case .generateBitUrl:
            return "\(encryptionPath)customer/fetchBitUrl"
        case .getClosureReasons:
            return "\(encryptionPath)customer/getClosureReasons"
        case .accountClosure:
            return "\(encryptionPath)customer/accountClosure"
        case .addVehicle:
            return "\(encryptionPath)vehicle/add"
        case .fetchTagClass:
            return "\(encryptionPath)vehicle/fetchTagClass"
        case .fetchTagFee:
            return "\(encryptionPath)vehicle/fetchTagFee"
        case .changeTagStatus:
            return "\(encryptionPath)vehicle/changeTagStatus"
        case .requestCallBack:
            return "\(encryptionPath)customer/requestCallback"
        case .registerCustomer:
            return "\(encryptionPath)customer/register"
        case .fetchAllCards:
            return "\(encryptionPath)customer/fetchAllCards"
        case .getReferenceId:
            return "\(encryptionPath)upi/v1/wrapper/pg/getReferenceId"
        case .fetchTransactionByTxnId:
            return "\(encryptionPath)upi/v1/wrapper/transaction/fetchTransactionByTxnId"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .checkRegisterCustomer, .forgotMpin, .generateOtp,
                .validateOtp, .customerUpdate, .fetchCustomer,
                .login, .fetchTransactions, .getBalance, .fetchVehicles,
                .getCardList, .vehicleTransactions, .disputeEntity, .fetchPgUrl,
                .detailTransaction, .getTags, .replaceFastTag, .getBanners,
                .fetchVkycLink, .fitmentCertificate, .pairPublicKey,
                .pairSDKPublicKey, .generateBitUrl, .getClosureReasons,
                .addVehicle, .fetchTagClass, .fetchTagFee, .accountClosure, .changeTagStatus, .requestCallBack, .registerCustomer, .fetchAllCards, .getReferenceId, .fetchTransactionByTxnId:
            return .post
        default:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .checkRegisterCustomer:
            return ["Content-Type": "application/json",
                    "tenant": TENANT,
                    "token": TOKEN,
                    "reqid": DEVICEID]
            
        case .forgotMpin, .generateOtp, .validateOtp, .login, .updateUser, .getTags, .registerCustomer:
            return ["Content-Type": "application/json",
                    "tenant": TENANT,
                    "token": TOKEN,
                    "reqid": DEVICEID]
        case .customerUpdate, .fetchCustomer, .fetchTransactions, .getBalance, .fetchVehicles, .getCardList, .vehicleTransactions, .disputeEntity, .fetchPgUrl, .detailTransaction, .replaceFastTag,
                .fetchVkycLink, .getBanners, .fitmentCertificate,
                .getClosureReasons, .addVehicle, .fetchTagClass,
                .fetchTagFee, .accountClosure, .changeTagStatus, .requestCallBack, .fetchAllCards, .getReferenceId, .fetchTransactionByTxnId:
            return ["Content-Type": "application/json",
                    "accesstoken": "Bearer \(ACCESSTOKEN)",
                    "refreshtoken": "Bearer \(REFRESHTOKEN)",
                    "tenant": TENANT,
                    "reqid": DEVICEID]
        case .pairPublicKey:
            return [:]
        case .pairSDKPublicKey, .generateBitUrl:
            return ["Content-Type": "application/json",
                    "accesstoken": "Bearer \(ACCESSTOKEN)",
                    "refreshtoken": "Bearer \(REFRESHTOKEN)",
                    "tenant": TENANT,
                    "yaptenant": "LQFLEET",
                    "reqid": DEVICEID]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var url: URL {
        switch self {
        default:
            guard let urlString = URL(string: self.baseURL + self.path) else {
                fatalError("URL not found")
            }
            return urlString
        }
    }
    
    var encoding: ParameterEncoding {
        switch httpMethod {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
