//
//  TransactionDetailsRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 21/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol TransactionDetailsRoutingLogic {
    func routeToTrackIssueVC()
}

protocol TransactionDetailsDataPassing {
  var dataStore: TransactionDetailsDataStore? { get }
}

class TransactionDetailsRouter: NSObject, TransactionDetailsRoutingLogic, TransactionDetailsDataPassing {
  weak var viewController: TransactionDetailsViewController?
  var dataStore: TransactionDetailsDataStore?
   
    func routeToTrackIssueVC() {
        if let destinationVC =  UIStoryboard(name: Storyboard.ids.profile,
                                             bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.trackIssueVC) as? TrackIssueViewController, let sourceVC = viewController {
            TrackIssueConfigurator.configureModule(viewController: destinationVC)
            navigation(source: sourceVC, destination: destinationVC, isPresent: false)
        }
    }
    
    // MARK: Navigation
    func navigation(source: TransactionDetailsViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
}
