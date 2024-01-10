//
//  AppDelegate.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//

import UIKit
import IQKeyboardManagerSwift
import ZVProgressHUD
import FirebaseCore
import FirebaseRemoteConfig

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var remoteConfig: RemoteConfig?
    private var forceUpdateValues: ForceUpdateModel?
    private let alertView = ForceUpdateAlertView()
    private var privacyWindow: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DEVICEID = UIDevice.current.identifierForVendor?.uuidString ?? "23057d90532485e0"
        /* KeyBoard config */
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
        /* Loader config */
        ZVProgressHUD.setMaskType(.black)
        ZVProgressHUD.setDisplayStyle(.custom((backgroundColor: UIColor.primaryColor, foregroundColor: .white)))
        ZVProgressHUD.setLogo(UIImage(named: "logo", in: nil, compatibleWith: nil))
        ZVProgressHUD.setLogoSize(CGSize(width: 35, height: 35))
        ZVProgressHUD.setTitleLabelFont(.systemFont(ofSize: 12))
        
        FirebaseApp.configure()
        
        if let initialVC = UIStoryboard(name: Storyboard.ids.initial,
                                       bundle: nil).instantiateViewController(withIdentifier:
                                       Controller.ids.initialViewController) as? InitialViewController {
            let navController = UINavigationController(rootViewController: initialVC)
            InitialConfigurator.configureModule(viewController: initialVC)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if isSensitiveData {
            self.showPrivacy()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        self.hidePrivacy()
        // setup remote config
        setUpRemoteConfig()
    }
}
// MARK: Privacy Controller
extension AppDelegate {
    private func showPrivacy() {
        let privacyViewController = Privacy.privacyViewController()
        privacyWindow = UIWindow(frame: UIScreen.main.bounds)
        privacyWindow?.rootViewController = privacyViewController
        privacyWindow?.makeKeyAndVisible()
    }
    private func hidePrivacy() {
        privacyWindow?.isHidden = true
        privacyWindow = nil
    }
}

// MARK: Firebase Force Update
extension AppDelegate {
    
    private func setUpRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigSettings = RemoteConfigSettings()
        remoteConfigSettings.minimumFetchInterval = 0
        remoteConfig?.configSettings = remoteConfigSettings
        
        remoteConfig?.fetchAndActivate { (status, error) in
            if let error = error {
                printLog("Error fetching remote config: \(error.localizedDescription)")
                return
            }
            let inAppUpdateValue = self.remoteConfig?.configValue(forKey: "in_app_update").stringValue
            if let jsonData = inAppUpdateValue?.data(using: .utf8) {
                do {
                    let modelResponse = try JSONDecoder().decode(ForceUpdateModel.self, from: jsonData)
                    self.forceUpdateValues = modelResponse
                    if self.isForceUpdateRequired() {
                        self.showForceUpdateAlert()
                    } else {
                        if self.alertView.superview != nil {
                            self.alertView.removeFromSuperview()
                        }
                    }
                } catch let error {
                   printLog("Error decoding JSON:.., \(error)")
                }
            }
        }
    }
    
    // MARK: Check ForceUpdate Required
    private func isForceUpdateRequired() -> Bool {
        let currentVersion: Double = Double(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "") ?? 0.0
        return (self.forceUpdateValues?.forceUpdateCurrentVersion ?? 0.0 > currentVersion)
    }
    
    // MARK: Present Force Update Alert
    private func showForceUpdateAlert() {
        window?.addSubview(alertView)
        alertView.frame = window?.bounds ?? CGRect.zero
        alertView.setUpData(data: self.forceUpdateValues)
        alertView.onClikButton = {  tagVal in
            if tagVal == 1 {
                self.alertView.removeFromSuperview()
            } else {
                if let appStoreURL = URL(string: self.forceUpdateValues?.forceUpdateStoreUrl ?? "https://apps.apple.com/us/app/qwtag-zip-through-digitally/id6448750529") {
                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.alertView.removeFromSuperview()
                }
            }
        }
    }
}

struct Privacy {
    static func privacyViewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        guard let viewcontroller = storyBoard.instantiateInitialViewController() else {
            fatalError("cannot instantiate initial view contoller")
        }
        return viewcontroller
    }
}
