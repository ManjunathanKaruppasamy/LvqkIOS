//
//  Reachability.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//

import Foundation
import UIKit
import ZVProgressHUD
import SystemConfiguration

// MARK: VPN Connection - Dedection

struct VPNChecker {
    private static let vpnProtocolsKeysIdentifiers = [
        "tap", "tun", "ppp", "ipsec", "utun"
    ]

    static func isVPNActive() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings() else {
            return false
        }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
            let allKeys = keys.allKeys as? [String] else { return false }

        // Checking for tunneling protocols in the keys
        for key in allKeys {
            for protocolId in vpnProtocolsKeysIdentifiers
                where key.starts(with: protocolId) {
                showVPNAlert()
                return true
            }
        }
        return false
    }
    
    private static func showVPNAlert() {
        if let topViewController = UIApplication.getTopViewController() {
            topViewController.showMessageAlert(title: DeviceValidatorResult.vpnConnection.description, message: "", showRetry: true, retryTitle: "Ok", showCancel: false, onRetry: nil, onCancel: nil)
        }
    }
}

func isInternetAvailable() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    // swiftlint:disable force_unwrapping
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    if let topVC = UIApplication.getTopViewController() {
        if !isReachable, !(topVC is NoInternetViewController) {
            hideLoader()
            if let noInternetView = UIStoryboard(name: Storyboard.ids.noInternet,
                                                 bundle: nil).instantiateViewController(withIdentifier:
                                                 Controller.ids.noInternetViewController) as? NoInternetViewController {
                NoInternetConfigurator.configureModule(viewController: noInternetView)
                noInternetView.modalPresentationStyle = .fullScreen
                topVC.present(noInternetView, animated: true, completion: nil)
            }
        } else if isReachable, topVC is NoInternetViewController {
            topVC.dismiss(animated: true, completion: nil)
        } else {
            /* NoInternet Controller already presented */
        }
    }
    return (isReachable && !needsConnection)
}

/* Show API Loader */
func showLoader(text: String = "Loading..") {
    DispatchQueue.main.async {
        ZVProgressHUD.show(with: text, delay: 0)
    }
}

/* Hide API Loader */
func hideLoader() {
    ZVProgressHUD.dismiss()
}
