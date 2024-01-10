//
//  InitialInteractor.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import CryptoSwift
import SwCrypt
@_implementationOnly import IOSSecuritySuite

protocol InitialBusinessLogic {
    func checksForValidLaunch()
    func keyPairExchange()
    func mobileNumberData()
}

protocol InitialDataStore {
   
}

class InitialInteractor: InitialBusinessLogic, InitialDataStore {
    var presenter: InitialPresentationLogic?
    var worker: InitialWorker?
    
    /* Check For Valid Launch */
    func checksForValidLaunch() {
        if CHECKROOTEDDEVICE == true {
            let jailbreakStatusFailMessage = IOSSecuritySuite.amIJailbrokenWithFailMessage()
            let jailbreakStatusCheckFail = IOSSecuritySuite.amIJailbrokenWithFailedChecks()
            
            if jailbreakStatusFailMessage.jailbroken || IOSSecuritySuite.amIRunInEmulator() || IOSSecuritySuite.amIDebugged() || IOSSecuritySuite.amIReverseEngineered() || IOSSecuritySuite.amIReverseEngineered() || IOSSecuritySuite.amIProxied() || IOSSecuritySuite.amIJailbroken() {
                self.presenter?.validLaunchChecker(result: .deviceJailBroken)
            }
            
            if jailbreakStatusCheckFail.jailbroken {
                if (jailbreakStatusCheckFail.failedChecks.contains { $0.check == .existenceOfSuspiciousFiles }) && (jailbreakStatusCheckFail.failedChecks.contains { $0.check == .suspiciousFilesCanBeOpened }) {
                    self.presenter?.validLaunchChecker(result: .deviceJailBroken)
                }
            }
            if UIDevice.current.isJailBroken {
                self.presenter?.validLaunchChecker(result: .deviceJailBroken)
            } else if VPNChecker.isVPNActive() {
                self.presenter?.validLaunchChecker(result: .vpnConnection)
            } else {
                self.presenter?.validLaunchChecker(result: .success)
            }
        } else {
            self.presenter?.validLaunchChecker(result: .success)
        }
    }
    
    /* KeyPair Exchange */
    func keyPairExchange() {
        let keys = try? CC.EC.generateKeyPair(256)
        clientPrivateKeyString = keys?.0.toHexString() ?? ""
        let pubKey = try? CC.EC.getPublicKeyFromPrivateKey(keys?.0 ?? Data())
        clientPublicKeyString = pubKey?.toHexString() ?? ""
        self.pairPublicKey()
    }
    
    /* Pair PublicKey */
    private func pairPublicKey() {
        let requestDict = [
            "reqId": DEVICEID,
            "publicKey": clientPublicKeyString
        ]
        worker?.fetchPairPublicKey(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                sharedSecret = response.result?.sharedSecret ?? ""
                serverPublickey = response.result?.serverPublicKey ?? ""
                self.presenter?.validKeyExchange(status: true)
            } else {
                self.presenter?.validKeyExchange(status: false)
            }
        })
    }
    
    // MARK: Get Mobile Number Data
    func mobileNumberData() {
        if !userMobileNumber.isEmpty {
            let requestDict = [
                "mobile": userMobileNumber,
                "appGuid": DEVICEID,
                "version": APPVERSION,
                "platform": PLATFORM
            ]
            worker?.callRegisterCustomer(params: requestDict, completion: { results, code in
                if let response = results, code == 200 {
                    let customerResponse = Initial.Fetchkits.Response(response: response)
                    self.presenter?.presentMobileNumberKitsList(response: customerResponse)
                } else {
                    showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
                }
            })
        } else {
            let response = Initial.Fetchkits.Response()
            self.presenter?.presentMobileNumberKitsList(response: response)
        }
    }
    
}
