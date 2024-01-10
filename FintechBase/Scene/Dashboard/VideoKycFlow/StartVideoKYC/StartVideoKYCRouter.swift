//
//  StartVideoKYCRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol StartVideoKYCRoutingLogic {
    func routeToUserConsentVC()
    func routeToVKYCVC()
}

protocol StartVideoKYCDataPassing {
  var dataStore: StartVideoKYCDataStore? { get }
}

class StartVideoKYCRouter: NSObject, StartVideoKYCRoutingLogic, StartVideoKYCDataPassing {
  weak var viewController: StartVideoKYCViewController?
  var dataStore: StartVideoKYCDataStore?
    
    /* Route To UserConsentVC */
    func routeToUserConsentVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.userConsentViewController) as? UserConsentViewController, let sourceVC =  viewController {
            destinationVC.delegate = viewController
            UserConsentConfigurator.configureModule(viewController: destinationVC)
//            var destinationDataStore = destinationVC.router?.dataStore
//            self.passDataToMPINController(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    /* Route To VkycVC */
    func routeToVKYCVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.vkycWebViewController) as? VKYCWebViewController, let sourceVC =  viewController {
            
            VKYCWebConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToVKYCController(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    // MARK: Navigation
    func navigation(source: StartVideoKYCViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            destination.modalPresentationStyle = .overFullScreen
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data To VKYC Controller
      private func passDataToVKYCController(source: StartVideoKYCDataStore?, destination: inout VKYCWebDataStore?) {
          destination?.loadLink = source?.vkycLink ?? ""
      }
}
