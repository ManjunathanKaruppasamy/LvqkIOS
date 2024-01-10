//
//  VehicleRouter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol VehicleRoutingLogic {
    func routeToVehicleDetailsVC()
    func routeToQWTagBottomViews()
    func routeToAddVehicleVC()
}

protocol VehicleDataPassing {
  var dataStore: VehicleDataStore? { get }
}

class VehicleRouter: NSObject, VehicleRoutingLogic, VehicleDataPassing {
  weak var viewController: VehicleViewController?
  var dataStore: VehicleDataStore?
    private var qwTagCustomView = GetQWTagView()
    
    /* Route To VehicleDetailsVC */
    func routeToVehicleDetailsVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.vehicleDetailsViewController) as? VehicleDetailsViewController, let sourceVC =  viewController {
            destinationVC.isViewAllTapped = { isFromViewAll in
                self.viewController?.tabBarController?.selectedIndex = isFromViewAll ? 2 : 1
                self.viewController?.navigationController?.popViewController(animated: !isFromViewAll)
            }
            
            VehicleDetailsConfigurator.configureModule(viewController: destinationVC)
            var destinationDataStore = destinationVC.router?.dataStore
            self.passDataToVehicleDetailsdController(source: dataStore, destination: &destinationDataStore)
            
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Route to QW Tag Bottom Sheets
    func routeToQWTagBottomViews() {
        self.qwTagCustomView = GetQWTagView(frame: CGRect(x: 0, y: 0, width: viewController?.view.frame.width ?? 0, height: viewController?.view.frame.height ?? 0))
        self.qwTagCustomView.onClickClose = { isTrue in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayerVisibilityNeedsToBeUpdate"), object: false)
            self.viewController?.tabBarController?.tabBar.isHidden = false
            self.qwTagCustomView.isHidden = true
        }
        self.qwTagCustomView.isVerifiedVehicle = { isVerified in
            self.qwTagCustomView.isHidden = true
           // self.routeToFastTagDetailVC()
        }
        self.viewController?.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayerVisibilityNeedsToBeUpdate"), object: true)
        viewController?.view.addSubview(qwTagCustomView)
    }
    /* Route To VehicleDetailsVC */
    func routeToAddVehicleVC() {
        if let destinationVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: Controller.ids.addVehicleViewController) as? AddVehicleViewController, let sourceVC =  viewController {
            AddVehicleConfigurator.configureModule(viewController: destinationVC)
            self.navigation(source: sourceVC, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigation(source: VehicleViewController, destination: UIViewController, isPresent: Bool = false) {
        if isPresent {
            source.navigationController?.present(destination, animated: true)
        } else {
            source.navigationController?.show(destination, sender: nil)
        }
    }
    
    // MARK: Passing data
      private func passDataToVehicleDetailsdController(source: VehicleDataStore?, destination: inout VehicleDetailsDataStore?) {
          destination?.vehicleStatus = source?.vehicleStatus
          destination?.vehicleListResultArray = source?.vehicleListResultArray
      }
}
