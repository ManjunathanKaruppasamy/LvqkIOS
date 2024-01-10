//
//  ReasonsForClosureRouter.swift
//  FintechBase
//
//  Created by Sravani Madala on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

@objc protocol ReasonsForClosureRoutingLogic {
    func routeToCustomerSupportVC()
    func routeToBankAccountDetailsVC()
    func routeToNegativeBalanceVC()
}

protocol ReasonsForClosureDataPassing {
    var dataStore: ReasonsForClosureDataStore? { get }
}

class ReasonsForClosureRouter: NSObject, ReasonsForClosureRoutingLogic, ReasonsForClosureDataPassing {
    weak var viewController: ReasonsForClosureViewController?
    var dataStore: ReasonsForClosureDataStore?
    
    /* Route To CustomerSupportVC */
    /* Route To BankAccountDetailsVC */
    func routeToBankAccountDetailsVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.accountClosureStoryBoard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.bankAccountDetailsViewController) as? BankAccountDetailsViewController, let sourceVC =  viewController {
            BankAccountDetailsConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC)
        }
    }
    /* Route To CustomerSupportVC */
    func routeToCustomerSupportVC() {
        if let destinationVC =  self.viewController?.storyboard?.instantiateViewController(withIdentifier: Controller.ids.cusSupportVC) as? CustomerSupportViewController, let sourceVC = self.viewController {
            CustomerSupportConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    /* Route To NegativeBalanceVC */
    func routeToNegativeBalanceVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.accountClosureStoryBoard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.negativeBalanceViewController) as? NegativeBalanceViewController, let sourceVC =  viewController {
            NegativeBalanceConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigation(source: ReasonsForClosureViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
}
