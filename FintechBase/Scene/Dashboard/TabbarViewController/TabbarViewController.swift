//
//  TabbarViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol TabbarDisplayLogic: AnyObject {
    func getTabbarList(tablist: [UIViewController])
}

class TabbarViewController: UITabBarController {
  var interactor: TabbarBusinessLogic?
  var router: (NSObjectProtocol & TabbarRoutingLogic & TabbarDataPassing)?
  
    var navigateTo: Int? = 0
    var customTabBarView = UIView(frame: .zero)
    
  // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initalLoads()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            setupCustomTabBarFrame()
    }
}

// MARK: - Initial Setup
extension TabbarViewController {
    
    /* Initial Loads */
    private func initalLoads() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: .setCustomFont(name: .medium, size: .x10) as UIFont], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: .setCustomFont(name: .medium, size: .x10) as UIFont], for: .selected)

        self.loadData()
        setupTabBarUI()
        addCustomTabBarView(istrue: true)
        NotificationCenter.default.addObserver(self, selector: #selector(playerVisibilityNeedsChangeNotification(notif:)), name: Notification.Name(rawValue: "PlayerVisibilityNeedsToBeUpdate"), object: nil)

    }
    
    func changePlayerVisibility(show: Bool) {
        addCustomTabBarView(istrue: !show)
    }

    @objc func playerVisibilityNeedsChangeNotification(notif: Notification) {
        let show = notif.object as? Bool ?? false
        self.changePlayerVisibility(show: show)
    }
    
    /* Setup TabBar UI */
    private func setupTabBarUI() {
//        self.tabBar.layer.cornerRadius = 20
//        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .primaryColor
        self.tabBar.unselectedItemTintColor = .blusihGryColor
        self.tabBar.clipsToBounds = true
        
    }
    
    /* Load Data */
    func loadData() {
        interactor?.tabbarSetup()
    }
    
    /* Setup Custom Tabar Frame */
    private func setupCustomTabBarFrame() {
        let oldTabbarHeight = self.tabBar.frame.height
        let height = self.view.safeAreaInsets.bottom + 52
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        self.additionalSafeAreaInsets.bottom = height - oldTabbarHeight
        self.tabBar.frame = tabFrame
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
        customTabBarView.frame = tabBar.frame
    }
    
    /* Add Custom TabBar view */
    private func addCustomTabBarView(istrue: Bool) {
        if istrue {
            self.customTabBarView.isHidden = false
            self.customTabBarView.frame = tabBar.frame
            self.customTabBarView.backgroundColor = .white
    //        self.customTabBarView.layer.cornerRadius = 20
    //        self.customTabBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.customTabBarView.layer.masksToBounds = false
            self.customTabBarView.layer.shadowColor = UIColor.darkGray.cgColor
            self.customTabBarView.layer.shadowOffset = CGSize(width: 1, height: 1)
            self.customTabBarView.layer.shadowOpacity = 0.5
            self.customTabBarView.layer.shadowRadius = 5
            self.view.addSubview(customTabBarView)
            self.view.bringSubviewToFront(self.tabBar)
        } else {
            self.customTabBarView.isHidden = true
            self.customTabBarView.frame = .zero
        }
    }
}

// MARK: - DisplayLogic
extension TabbarViewController: TabbarDisplayLogic {
    func getTabbarList(tablist: [UIViewController]) {
        viewControllers = tablist
//        viewControllers?.forEach({
// //            $0.view.backgroundColor = .white
//        })
    }
}
