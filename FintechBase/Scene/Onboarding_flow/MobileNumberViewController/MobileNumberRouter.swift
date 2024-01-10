//
//  MobileNumberRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MobileNumberRoutingLogic {
    func routeToOTPController(isFromDigiLocker: Bool)
    func routeToMPINViewController()
    func routeToRequestSubmittedViewController()
    func routeToAccountDetailsVC(isNewUser: Bool)
    func routeToAadhaarVerificationVC()
}

protocol MobileNumberDataPassing {
  var dataStore: MobileNumberDataStore? { get }
}

class MobileNumberRouter: NSObject, MobileNumberRoutingLogic, MobileNumberDataPassing {
  weak var viewController: MobileNumberViewController?
  var dataStore: MobileNumberDataStore?
    
    /* Route To OTPController */
    func routeToOTPController(isFromDigiLocker: Bool = false) {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.otpViewController) as? OTPViewController, let sourceVC =  viewController {
            destinationVC.modalPresentationStyle = .overFullScreen
            destinationVC.verifyOTPTapped = { (otpString, showSuccessPopUp) in
                isFromDigiLocker ? self.routeToAadhaarVerificationVC() : self.routeToAccountDetailsVC(isNewUser: false)
            }
            OTPConfigurator.otpConfigureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToOTPController(source: dataStore, destination: &destinationDataStore, isFromDigiLocker: isFromDigiLocker)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    /* Route To AccountDetailsVC */
    func routeToAadhaarVerificationVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.aadhaarVerificationViewController) as? AadhaarVerificationViewController, let sourceVC =  viewController {
            
            destinationVC.onClickButton = {
                self.viewController?.invokeDigiLock()
            }
            AadhaarVerificationConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    /* Route To AccountDetailsVC */
    func routeToAccountDetailsVC(isNewUser: Bool) {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.accountDetailsViewController) as? AccountDetailsViewController, let sourceVC =  viewController {

            AccountDetailsConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToAccountDetailsVC(source: dataStore, destination: &destinationDataStore, isNewUser: isNewUser)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Enter MPIN VC
    func routeToMPINViewController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.commonMpinViewController) as? CommonMpinViewController, let sourceVC =  viewController {
            
            destinationVC.onCompletePin = {
                self.routeToTabbarController()
            }
            CommonMpinConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToMPINController(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: TabbarController
    func routeToTabbarController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.tabbarViewController) as? TabbarViewController, let sourceVC =  viewController {
            
            TabbarConfigurator.configureModule(viewController: destinationVC)
            
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    /* Route To RequestSubmittedViewController */
    func routeToRequestSubmittedViewController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.accountClosureStoryBoard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.requestSubmittedViewController) as? RequestSubmittedViewController, let sourceVC =  viewController {
            
            RequestSubmittedConfigurator.configureModule(viewController: destinationVC)
            
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToRequestSubmittedVC(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigation(source: MobileNumberViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data
      private func passDataToOTPController(source: MobileNumberDataStore?, destination: inout OTPDataStore?, isFromDigiLocker: Bool) {
          destination?.number = source?.number
          destination?.isFromForgot = false
          destination?.isNewUser = isFromDigiLocker
      }
    
    // MARK: Passing data MPIN Type
      private func passDataToMPINController(source: MobileNumberDataStore?, destination: inout CommonMpinDataStore?) {
          destination?.type = .enterMpin
      }
    
    // MARK: Passing data AccountDetails
    private func passDataToAccountDetailsVC(source: MobileNumberDataStore?, destination: inout AccountDetailsDataStore?, isNewUser: Bool) {
          destination?.isNewUser = isNewUser
          destination?.digiLockerResponse = source?.digiLockerResponse
      }
    
    // MARK: Passing data to RequestSubmittedViewController
    private func passDataToRequestSubmittedVC(source: MobileNumberDataStore?, destination: inout RequestSubmittedDataStore?) {
        destination?.accountCloseScreen = .inProgress
    }
}
