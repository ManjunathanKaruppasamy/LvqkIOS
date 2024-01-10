//
//  InitialRouter.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol InitialRoutingLogic {
    var navigationController: UINavigationController? { get }
    func routeToWalkThrough()
    func routeToMPINViewController()
    func routeToTabbarController()
    func routeToRequestSubmittedViewController()
}

protocol InitialDataPassing {
    var dataStore: InitialDataStore? { get }
}

class InitialRouter: NSObject, InitialRoutingLogic, InitialDataPassing {
    var navigationController: UINavigationController?
    weak var viewController: InitialViewController?
    var dataStore: InitialDataStore?
    
    // MARK: Route To WalkThroughViewController
    func routeToWalkThrough() {
        let storyboard = UIStoryboard(name: Storyboard.ids.onboardingStoryboard, bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: Controller.ids.walkThroughViewController) as? WalkThroughViewController {
            WalkThroughConfigurator.walkThroughConfigureModule(viewController: destinationVC)
            navigation(source: viewController ?? InitialViewController(), destination: destinationVC)
        }
    }
    
    // MARK: Route To EnterMPINVC
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
    
    // MARK: Route To TabbarController
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
    private func navigation(source: InitialViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data
      private func passDataToMPINController(source: InitialDataStore?, destination: inout CommonMpinDataStore?) {
          destination?.type = .enterMpin
      }
    // MARK: Passing data to RequestSubmittedViewController
    private func passDataToRequestSubmittedVC(source: InitialDataStore?, destination: inout RequestSubmittedDataStore?) {
        destination?.accountCloseScreen = .inProgress
    }
}
