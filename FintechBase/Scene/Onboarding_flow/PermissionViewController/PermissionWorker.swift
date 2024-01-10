//
//  PermissionWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

import Foundation
import CoreLocation
import Contacts

class PermissionWorker: NSObject {
    
    lazy var contactStore: CNContactStore = {
        let store = CNContactStore()
        return store
    }()
    
    lazy var locationManager: CLLocationManager = {
        let location = CLLocationManager()
        location.delegate = self
        return location
    }()
    
    var checkLocationOnce: Bool = false
    private var locationCompletion: ((_ accessGranted: Bool) -> Void)?
    private var contactCompletion: ((_ accessGranted: Bool) -> Void)?
    
    // MARK: - Contact Permission
    func requestContactAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        self.contactCompletion = completionHandler
        getContactStatus(status: CNContactStore.authorizationStatus(for: .contacts))
    }
    
    /* Check Contact Authorization Status */
    func getContactStatus(status: CNAuthorizationStatus) {
        switch status {
        case .notDetermined:
            contactStore.requestAccess(for: .contacts) { [weak self] granted, error in
                if granted {
                    self?.contactCompletion?(true)
                } else {
                    self?.contactCompletion?(false)
                }
            }
        case .denied, .restricted:
            contactCompletion?(false)
        case .authorized:
            contactCompletion?(true)
        default:
            contactCompletion?(false)
        }
    }
    
    // MARK: - Location Permission
    func requesLocationPermission(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        locationCompletion = completionHandler
        getLocationStatus(status: CLLocationManager.authorizationStatus())
    }
    
    /* Get Location Authorization Status */
    func getLocationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            locationCompletion?(false)
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            locationCompletion?(true)
        default:
            locationCompletion?(false)
        }
    }
    
    /* Get Location Permission Status */
    func getLocationPermissionStatus(completionHandler: @escaping (_ locationStatus: CLAuthorizationStatus) -> Void) {
        completionHandler(CLLocationManager.authorizationStatus())
    }
}

extension PermissionWorker: CLLocationManagerDelegate {
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            if #available(iOS 14.0, *) {
                self.getLocationStatus(status: manager.authorizationStatus)
            } else {
                // Fallback on earlier versions
                self.getLocationStatus(status: CLLocationManager.authorizationStatus())
            }
        }
    }
}
