//
//  BankAccountDetailsRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol BankAccountDetailsRoutingLogic {
    func routeToUploadDocumentVC()
}

protocol BankAccountDetailsDataPassing {
    var dataStore: BankAccountDetailsDataStore? { get }
}

class BankAccountDetailsRouter: NSObject, BankAccountDetailsRoutingLogic, BankAccountDetailsDataPassing {
    weak var viewController: BankAccountDetailsViewController?
    var dataStore: BankAccountDetailsDataStore?
    
    /* Route To UploadDocumentVC */
    func routeToUploadDocumentVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.accountClosureStoryBoard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.uploadDocumentViewController) as? UploadDocumentViewController, let sourceVC =  viewController {
            UploadDocumentConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigation(source: BankAccountDetailsViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
}
