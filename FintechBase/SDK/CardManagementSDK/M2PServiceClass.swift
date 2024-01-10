//
//  M2PServiceClass.swift
//  DemoApp
//
//  Created by SIDHUDEVARAYAN K C on 22/02/22.
//  Copyright © 2022 Ranjith Ravichandran. All rights reserved.
//

import Foundation
import UIKit
@_implementationOnly import Alamofire
import PCIWidget
@_implementationOnly import ObjectMapper
import SwCrypt
import CryptoSwift
import CryptoKit

// MARK: - Crypto Kit Encryption & Decryption
extension InvokeCardManagementSdk {

    func initialKeyHandle() {
        let keys = try? CC.EC.generateKeyPair(256)
        self.privateKeyString = keys?.0.toHexString().uppercased() ?? ""
        let pubKey = try? CC.EC.getPublicKeyFromPrivateKey(keys?.0 ?? Data())
        self.publicLocalString = pubKey?.toHexString().uppercased()
        self.pair()
    }

    func pair() {
        guard isInternetAvailable() else {
            return
        }
        let params: Parameters = [
            "entityId": M2PCD.shared.m2pCDParams?["entityId"] ?? "",
            "publicKey": self.publicLocalString ?? "",
            "appGuid": DEVICEID
        ]

        /*API Call in web service class*/
        APIManager.shared().call(type: EndpointItem.pairSDKPublicKey, parameter: params) { (response: M2PResponseModel?, error, code, headLessResponse) in
            if response?.result ?? false, code == 200 {
                // Paired
                self.generateBitUrl()
            } else if response?.exception?.errorCode == "Y3271"{
                UserDefaults.standard.setValue("", forKey: "M2P_PUBLIC")
                UserDefaults.standard.setValue("", forKey: "M2P_PRIVATE")
                self.presentViewController.showMessageAlert(title: UIViewController.AlertTitle.alert.rawValue, message: response?.exception?.detailMessage, showRetry: true, retryTitle: "Call Support", showCancel: true, cancelTitle: "Close") {
                    if let url = URL(string: "tel://\(M2PCD.shared.supportContactNumber ?? "")"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    } else {
//                        print("check in real device/Support number is not configured")
                    }
                } onCancel: {
                    //
                }
            } else {
                UserDefaults.standard.setValue("", forKey: "M2P_PRIVATE")
                UserDefaults.standard.setValue("", forKey: "M2P_PUBLIC")
//                print("Error in Pair \(error?.description ?? "Error in Pair")")
                self.presentViewController.alertWithNoAction(title: response?.exception?.detailMessage ?? ERROR, completion: { success in
                    // Error
                })
            }
        }
    }

    func generateBitUrl() {
        guard isInternetAvailable() else {
            return
        }
        var params: Parameters = M2PCD.shared.m2pCDParams ?? [:]
        params["endPoint"] = true
        /*API Call in web service class*/
        APIManager.shared().call(type: EndpointItem.generateBitUrl, parameter: params) { (response: M2PBitUrlResponseModel?, error, code, headLessResponse) in
            if let senderPublicKey = response?.result?.publicKey, code == 200 {
                self.publicServerString = senderPublicKey
                self.dynamicURLKey = response?.result?.url

                // Invoke the SDK by passing the public, private keys
                M2PCD.shared.dynamicURLString = self.dynamicURLKey
                M2PCD.shared.privateKeyString = self.privateKeyString
                M2PCD.shared.serverPublicString = self.publicServerString

                M2PCD.shared.present(from: self.presentViewController) // Present the SDK
            } else {
//                print("Error in generateBitUrl \(error?.description ?? "Error in generateBitUrl")")
                self.presentViewController.alertWithNoAction(title: response?.exception?.detailMessage ?? ERROR, completion: { success in
                    // Error
                })
            }
        }
    }

}

extension Data {
  /// docs
  public init(hex: String) {
    self.init([UInt8](hex: hex))
  }
  
  /// docs
  public var bytes: [UInt8] {
    Array(self)
  }
  
  /// docs
  public func toHexString() -> String {
    self.bytes.toHexString()
  }
}

extension Array where Element == UInt8 {
  /// docs
  public func toHexString() -> String {
    `lazy`.reduce(into: "") {
      var strM = String($1, radix: 16)
      if strM.count == 1 {
          strM = "0" + strM
      }
      $0 += strM
    }
  }
}
