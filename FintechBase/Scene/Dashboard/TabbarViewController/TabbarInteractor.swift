//
//  TabbarInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol TabbarBusinessLogic {
    func tabbarSetup()
}

protocol TabbarDataStore {
  // var name: String { get set }
}

class TabbarInteractor: TabbarBusinessLogic, TabbarDataStore {
  var presenter: TabbarPresentationLogic?
  var worker: TabbarWorker?
    var tabbarViewcontrollers = [UIViewController]()
  
    // MARK: tabbarSetup
    func tabbarSetup() {
        self.setupTabBar()
        presenter?.presentTab(tabControllers: tabbarViewcontrollers)
    }
    
    /* Setup TabBar */
    func setupTabBar() {
        
        let  bundle = Bundle(for: type(of: self))
        
        guard let homeVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                        bundle: bundle).instantiateViewController(withIdentifier: Controller.ids.dashboardViewController) as? DashboardViewController else {
            return }
        guard let vehicleVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                                    bundle: bundle).instantiateViewController(withIdentifier: Controller.ids.vehicleViewController) as? VehicleViewController else {
            return }
        guard let transactionVC = UIStoryboard(name: Storyboard.ids.dashboard,
                                            bundle: bundle).instantiateViewController(withIdentifier: Controller.ids.transactionViewController) as? TransactionViewController else {
            return }
        guard let profileVC = UIStoryboard(name: Storyboard.ids.profile,
                                        bundle: bundle).instantiateViewController(withIdentifier: Controller.ids.settingsVC) as? SettingsViewController else {
            return }
        
        DashboardConfigurator.configureModule(viewController: homeVC)
        VehicleConfigurator.configureModule(viewController: vehicleVC)
        TransactionConfigurator.configureModule(viewController: transactionVC)
        SettingsConfigurator.configureModule(viewController: profileVC)
        
        // MARK: - ViewControllers without Navigationstack
        
        homeVC.tabBarItem.image =  UIImage(named: Image.imageString.home)
        homeVC.tabBarItem.selectedImage =  UIImage(named: Image.imageString.homeSelected)
        homeVC.tabBarItem.title = AppLoacalize.textString.home
        
        vehicleVC.tabBarItem.image =  UIImage(named: Image.imageString.vehicle)
        vehicleVC.tabBarItem.selectedImage =  UIImage(named: Image.imageString.vehicleSelected)
        vehicleVC.tabBarItem.title = AppLoacalize.textString.vehicle
        
        transactionVC.tabBarItem.image =  UIImage(named: Image.imageString.transaction)
        transactionVC.tabBarItem.selectedImage =  UIImage(named: Image.imageString.transactionSelected)
        transactionVC.tabBarItem.title = AppLoacalize.textString.transaction
        
        profileVC.tabBarItem.image =  UIImage(named: Image.imageString.profileUnselected)
        profileVC.tabBarItem.selectedImage =  UIImage(named: Image.imageString.profileSelected)
        profileVC.tabBarItem.title = AppLoacalize.textString.profile
        
        tabbarViewcontrollers =  [homeVC, vehicleVC, transactionVC, profileVC]
    }
}
