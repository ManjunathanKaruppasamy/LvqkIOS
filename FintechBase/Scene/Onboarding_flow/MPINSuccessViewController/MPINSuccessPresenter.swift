//
//  MPINSuccessPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 02/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MPINSuccessPresentationLogic {
    func passBiometricData(isFailed: Bool, alertData: AlertData?)
    func sendSetupViewDate(setMPINView: SetMPINView)
}

class MPINSuccessPresenter: MPINSuccessPresentationLogic {
  weak var viewController: MPINSuccessDisplayLogic?
  
    // MARK: Biometric Present Data
    func passBiometricData(isFailed: Bool, alertData: AlertData?) {
        viewController?.displayBiometricStatus(isFailed: isFailed, alertData: alertData)
    }
    
    /* Send SetupView Date */
    func sendSetupViewDate(setMPINView: SetMPINView) {
        self.viewController?.displaySetupViewDate(setMPINView: setMPINView)
    }
}
