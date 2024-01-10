//
//  InitialViewController.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol InitialDisplayLogic: AnyObject {
    func preLaunchValidator(result: DeviceValidatorResult)
    func keyExchange(status: Bool)
    func mobileNumberData(response: Initial.Fetchkits.ViewModel)
}

class InitialViewController: UIViewController {
    var interactor: InitialBusinessLogic?
    var router: (NSObjectProtocol & InitialRoutingLogic & InitialDataPassing)?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkValidLaunch()
    }
    
    /* Check Valid Launch */
    private func checkValidLaunch() {
        interactor?.checksForValidLaunch()
    }
    
}

// MARK: <InitialDisplayLogic> Delegate methods
extension InitialViewController: InitialDisplayLogic {
    
    /* PreLaunch Validator */
    func preLaunchValidator(result: DeviceValidatorResult) {
        switch result {
        case .deviceJailBroken:
            self.showMessageAlert(title: result.description, message: "",
                                  showRetry: true, retryTitle: "Close", showCancel: false, onRetry: {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    exit(0)
                }
            }, onCancel: nil)
        case .vpnConnection:
            self.showMessageAlert(title: "", message: result.description,
                                  showRetry: true, retryTitle: "Ok", showCancel: false, onRetry: nil, onCancel: nil)

        case .success:
            self.interactor?.keyPairExchange()
        }
    }
    
    /* Key Exchange */
    func keyExchange(status: Bool) {
        if status {
            self.interactor?.mobileNumberData()
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
        }
    }
    
    func mobileNumberData(response: Initial.Fetchkits.ViewModel) {
        if response.viewModel?.isAccountClosed == "true" {
            self.router?.routeToRequestSubmittedViewController()
        } else {
            switch response.viewModel?.status {
            case CustomerStatus.success.rawValue:
                self.router?.routeToMPINViewController()
            case CustomerStatus.failed.rawValue:
                self.router?.routeToWalkThrough()
            default:
                self.router?.routeToWalkThrough()
            }
        }
    }
    
}
