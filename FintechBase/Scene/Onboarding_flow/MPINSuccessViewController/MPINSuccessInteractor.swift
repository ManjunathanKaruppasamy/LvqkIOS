//
//  MPINSuccessInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 02/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import LocalAuthentication

protocol MPINSuccessBusinessLogic {
    func callBiometric()
    func getSetupViewDate()
}

protocol MPINSuccessDataStore {
     var setMPINView: SetMPINView? { get set }
}

class MPINSuccessInteractor: MPINSuccessBusinessLogic, MPINSuccessDataStore {
    
    var presenter: MPINSuccessPresentationLogic?
    var worker: MPINSuccessWorker?
    var context = LAContext()
    var setMPINView: SetMPINView?
    
    // MARK: Trigger Biometric
    func callBiometric() {
        isSensitiveData = false
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We’ve detected that your phone supports access using thumb/face recognition :)"
            context.localizedFallbackTitle = ""
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] issuccess, authenticationError in
                DispatchQueue.main.async {
                    if issuccess {
                        isSensitiveData = true
                        self?.presenter?.passBiometricData(isFailed: false, alertData: nil)
                    } else {
                        // error
                        isSensitiveData = true
                        self?.presenter?.passBiometricData(isFailed: true, alertData: AlertData(alertTitle: AppLoacalize.textString.authenticationFailed, alertMessage: AppLoacalize.textString.authenticationFailedDesc))
                    }
                }
            }
        } else {
            // no biometry
            // print("unAvailable", error?.localizedDescription ?? "")
            self.presenter?.passBiometricData(isFailed: true, alertData: AlertData(alertTitle: error?.localizedDescription ?? AppLoacalize.textString.biometryUnavailable, alertMessage: AppLoacalize.textString.biometryUnavailableDesc))
        }
    }
    
    /* Get SetupView Date */
    func getSetupViewDate() {
        self.presenter?.sendSetupViewDate(setMPINView: self.setMPINView ?? .successShowMPIN)
    }
}
