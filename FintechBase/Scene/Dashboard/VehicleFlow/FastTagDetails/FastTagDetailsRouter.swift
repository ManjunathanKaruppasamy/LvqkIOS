//
//  FastTagDetailsRouter.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol FastTagDetailsRoutingLogic {
    func routeToAddAddressVC()
    func routeToUPIAppVC()
    func routeToPayUVC()
}

protocol FastTagDetailsDataPassing {
    var dataStore: FastTagDetailsDataStore? { get }
}

class FastTagDetailsRouter: NSObject, FastTagDetailsRoutingLogic, FastTagDetailsDataPassing {
    weak var viewController: FastTagDetailsViewController?
    var dataStore: FastTagDetailsDataStore?
    
    /* Route To AddAddressVC */
    func routeToAddAddressVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.addAddressViewController) as? AddAddressViewController, let sourceVC =  viewController {
            AddAddressConfigurator.configureModule(viewController: destinationVC)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    /* Route To UPI App VC */
    func routeToUPIAppVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.upiAppsBottomSheetViewController) as? UPIAppsBottomSheetViewController, let sourceVC =  viewController {
            
            UPIAppsBottomSheetConfigurator.configureModule(viewController: destinationVC)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    /* Pass data to PayUDataVC */
    private func passDataToPayUDataVC(source: FastTagDetailsDataStore?, destination: inout PayUDataStore?) {
        destination?.loadLink = viewController?.payUResponse?.result ?? ""
        destination?.isAccountClose = true
    }
    
    /* Route To PayUVC */
    func routeToPayUVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.payUViewController) as? PayUViewController, let sourceVC =  viewController {
            
            PayUConfigurator.configureModule(viewController: destinationVC)
            destinationVC.payUStatus = { isSuccess in
//                self.viewController?.fetchBalance()
                self.viewController?.addVehicleApiIntegrate()
            }
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToPayUDataVC(source: dataStore, destination: &destinationDataStore)
            self.navigation(source: sourceVC, destination: destinationVC, isPresent: true)
        }
    }
    
    // MARK: Navigation
    func navigation(source: FastTagDetailsViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
}
