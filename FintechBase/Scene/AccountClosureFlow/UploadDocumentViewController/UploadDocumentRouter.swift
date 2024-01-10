//
//  UploadDocumentRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol UploadDocumentRoutingLogic {
    func routeToOTPController()
    func routeToVerficationViewController()
}

protocol UploadDocumentDataPassing {
    var dataStore: UploadDocumentDataStore? { get }
}

class UploadDocumentRouter: NSObject, UploadDocumentRoutingLogic, UploadDocumentDataPassing {
    weak var viewController: UploadDocumentViewController?
    var dataStore: UploadDocumentDataStore?
    
    /* Route To OTPViewController */
    func routeToOTPController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.otpViewController) as? OTPViewController, let sourceVC =  viewController {
            destinationVC.verifyOTPTapped = { (otpString, showSuccessPopUp) in
                self.routeToVerficationViewController()
            }
            OTPConfigurator.otpConfigureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToOTPController(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    /* Route To VerficationViewController */
    func routeToVerficationViewController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.accountClosureStoryBoard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.verficationViewController) as? VerficationViewController, let sourceVC =  viewController {
            
            VerficationConfigurator.configureModule(viewController: destinationVC)
            destinationVC.isApiSuccess = { (isSuccess, message) in
                if isSuccess {
                    AddVehicleData.sharedInstace.destroy()
                    self.routeToRequestSubmittedViewController(accountCloseScreen: .submitted)
                } else {
                    self.routeToRequestSubmittedViewController(accountCloseScreen: .inProgress)
                }
            }
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToVerficationController(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    /* Route To RequestSubmittedViewController */
    func routeToRequestSubmittedViewController(accountCloseScreen: AccountCloseScreen) {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.accountClosureStoryBoard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.requestSubmittedViewController) as? RequestSubmittedViewController, let sourceVC =  viewController {
            
            RequestSubmittedConfigurator.configureModule(viewController: destinationVC)
            
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToRequestSubmittedVC(source: dataStore, destination: &destinationDataStore, accountCloseScreen: accountCloseScreen)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    // MARK: Navigation
    func navigation(source: UploadDocumentViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data to OtpVC
    private func passDataToOTPController(source: UploadDocumentDataStore?, destination: inout OTPDataStore?) {
        destination?.number = userMobileNumber
        destination?.isFromAccountClose = true
    }
    // MARK: Passing data to RequestSubmittedViewController
    private func passDataToRequestSubmittedVC(source: UploadDocumentDataStore?, destination: inout RequestSubmittedDataStore?, accountCloseScreen: AccountCloseScreen) {
        destination?.accountCloseScreen = accountCloseScreen
    }
    
    // MARK: Passing data to VerficationViewController
    private func passDataToVerficationController(source: UploadDocumentDataStore?, destination: inout VerficationDataStore?) {
        destination?.flowFromVC = .accountClosure
    }
}
