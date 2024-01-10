//
//  CommonFunctions.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//

import Foundation
import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class CommonFunctions {
    
    static func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    static func closeApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    static func convertDateFormate(dateString: String, inputFormate: DateFormate = .ddMMyyyy, outputFormate: DateFormate = .ddMMyyyy) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormate.rawValue
        let date = dateFormatter.date(from: dateString) ?? Date()
        
        dateFormatter.dateFormat = outputFormate.rawValue
        let dateString = dateFormatter.string(from: date )
        return dateString
    }
    
    // MARK: Get Vehicle Status
    func getVehicleStatus(kitStatus: String) -> VehicleStatus {
        switch kitStatus {
        case "ALLOCATED", "NETC_NOTEXCEPTION", "NETC_LOWBALANCE":
            return .active
        case "BLOCKED":
            return .blocked
        default:
            return .inActive
        }
    }
    
    // MARK: Fetch Transaction History Api
    func fetchTransactionHistory(isDateSelected: Bool? = true, fromDate: String?, toDate: String?, pageSize: String, pageNumber: String, completion: @escaping  (_ results: TransactionHistoryModel?,
                                                                                                                                                                  _ code: Int?) -> Void) {
        var parameterDictionary: Parameters = [
            "pageSize": pageSize,
            "pageNumber": pageNumber,
            "parentEntityId": ENTITYID ,
            "corporate": CORPORATE == "" ? TENANT.uppercased() : CORPORATE
        ]
        
        if isDateSelected == true {
            parameterDictionary["fromDate"] = fromDate
            parameterDictionary["toDate"] = toDate
        }
        
        APIManager.shared().call(type: EndpointItem.fetchTransactions, parameter: parameterDictionary) { (result: TransactionHistoryModel?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    // MARK: Fetch Balance
    func fetchBalance(completion: @escaping  (_ results: GetBalanceResponse?,
                                              _ code: Int?) -> Void) {
        let requestDict = [
            "mobile": ENTITYID
        ]
        APIManager.shared().call(type: EndpointItem.getBalance, parameter: requestDict) { (result: GetBalanceResponse?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: Load EmptyView in tableView Cell
    func loadEmptyViewForTableViewCell(message: String = "", cell: UITableViewCell) -> UIView {
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        let contentLebel = UILabel(frame: CGRect(x: 0, y: cell.frame.size.height / 2, width: emptyView.frame.size.width, height: 30))
        contentLebel.textAlignment = .center
        contentLebel.font = .setCustomFont(name: .semiBold, size: .x14)
        contentLebel.textColor = .darkGreyDescriptionColor
        contentLebel.text = message
        emptyView.addSubview(contentLebel)
        emptyView.backgroundColor = UIColor.white
        return emptyView
    }
    
    // MARK: Load EmptyView in CollectionView Cell
    func loadEmptyViewForCollectionViewCell(message: String = "", cell: UICollectionViewCell) -> UIView {
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        let contentLebel = UILabel(frame: CGRect(x: 0, y: cell.frame.size.height / 2, width: emptyView.frame.size.width, height: 30))
        contentLebel.textAlignment = .center
        contentLebel.font = .setCustomFont(name: .semiBold, size: .x14)
        contentLebel.textColor = .darkGreyDescriptionColor
        contentLebel.text = message
        emptyView.addSubview(contentLebel)
        emptyView.backgroundColor = UIColor.white
        return emptyView
    }
    
    // MARK: Timestamp DateFormatter
    func convertTimeStampToDate(date: Int?) -> String {
        if let timeResult = date {
            let unixTimeStamp: Double = Double(timeResult) / 1000.0
            let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
            let dateFormatt = DateFormatter()
            dateFormatt.dateFormat = "MMM dd-yyyy '-' hh:mm a"
            let localDate = dateFormatt.string(from: exactDate as Date)
            return localDate
        }
        return ""
    }
    
    // MARK: convert Lane No. from String
    func getLaneNo(name: String?) -> String {
        if let laneNumber = name {
            let fullNameArr = laneNumber.components(separatedBy: "|")
            if fullNameArr.count > 3 {
                return fullNameArr[2]
            }
            return ""
        }
        return ""
    }
    
    // MARK: Timestamp DateFormatter
    func getPGtransactionID() -> String {
        let timestamp = Date().timeIntervalSince1970
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let randomString = String((0..<6).map { _ in letters.randomElement() ?? String.Element(extendedGraphemeClusterLiteral: Character("1")) })
        let transactionID = randomString + String(Int64((timestamp * 1000.0).rounded()))
        return transactionID
    }
    
    func generateRandomBytes() -> [UInt8] {
//        let iv: [UInt8] = Array(repeating: UInt8(0), count: 16)
        var randomBytes = Array(repeating: UInt8(0), count: 16)
        for iValue in 0..<randomBytes.count {
            randomBytes[iValue] = UInt8.random(in: UInt8.min ... UInt8.max)
        }
        /*
        var randomBytes = [UInt8](repeating: 0, count: 12)
        for i in 0..<randomBytes.count {
            randomBytes[i] = UInt8(arc4random_uniform(256))
        }
         */
        return randomBytes
        // var iv = [UInt8](repeating: 0, count: 16)// let result = SecRandomCopyBytes(kSecRandomDefault, 16, &iv)// let randomString = Data(result).base64EncodedString()// return randomString
    }
    
}

extension Double {
    func roundToDecimal(_ fractionsDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionsDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
