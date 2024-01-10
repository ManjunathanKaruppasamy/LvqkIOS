//
//  AccountDetailsRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol AccountDetailsRoutingLogic {
    func routeToMPINViewController()
    func routeToStartKycViewController()
    func routeToVerifyAccount(isFromCreateAccount: Bool)
    func routeToSetEmailViewController()
}

protocol AccountDetailsDataPassing {
  var dataStore: AccountDetailsDataStore? { get }
}

class AccountDetailsRouter: NSObject, AccountDetailsRoutingLogic, AccountDetailsDataPassing {
  weak var viewController: AccountDetailsViewController?
  var dataStore: AccountDetailsDataStore?
    
    /* Route to CommonMpinVC */
    func routeToMPINViewController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.commonMpinViewController) as? CommonMpinViewController, let sourceVC =  viewController {
            
            CommonMpinConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToMPINController(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    /* Route to StartVideoKycVC */
    func routeToStartKycViewController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.startVideoKYCViewController) as? StartVideoKYCViewController, let sourceVC =  viewController {
            
            StartVideoKYCConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToStartKyc(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    /* Route to Verify Account */
    func routeToVerifyAccount(isFromCreateAccount: Bool) {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.verifyAccountViewController) as? VerifyAccountViewController, let sourceVC =  viewController {
            destinationVC.modalPresentationStyle = .overFullScreen
            destinationVC.isSuccess = { isSuccess in
            }
            VerifyAccountConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            destinationDataStore?.isFromCreateAccount = isFromCreateAccount
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    /* Route to SetEmailVC */
    func routeToSetEmailViewController() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.onboardingStoryboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.setEmailViewController) as? SetEmailViewController, let sourceVC =  viewController {
            destinationVC.passEmailValueDelegate = self.viewController.self
            SetEmailConfigurator.configureModule(viewController: destinationVC)
            var _ = destinationVC.router?.dataStore
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    // MARK: Navigation
    func navigation(source: AccountDetailsViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data
      private func passDataToMPINController(source: AccountDetailsDataStore?, destination: inout CommonMpinDataStore?) {
          destination?.type = .createMpin
          destination?.isFromForgot = false
      }
    
    // MARK: Passing data
      private func passDataToStartKyc(source: AccountDetailsDataStore?, destination: inout StartVideoKYCDataStore?) {
          destination?.flowEnum = source?.flowEnum
      }
}
