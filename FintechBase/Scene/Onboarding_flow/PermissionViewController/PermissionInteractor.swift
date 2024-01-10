//
//  PermissionInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import CoreLocation

protocol PermissionBusinessLogic {
    func getPermissionsData()
    func requestPermissions()
    func checkPermissionGranted(checkLocationOnce: Bool)
    func getLocationPermissionStatus()
}

protocol PermissionDataStore {
    var permissionArr: [PermissionList]? { get set }

}

class PermissionInteractor: PermissionBusinessLogic, PermissionDataStore {
    var permissionArr: [PermissionList]?
    var presenter: PermissionPresenterLogic?
    var worker: PermissionWorker?
      
    /* Get Permission Data */
    func getPermissionsData() {
        permissionArr = [
            PermissionList(title: AppLoacalize.textString.device, description: AppLoacalize.textString.deviceDesc, image: Image.imageString.device),
            
            PermissionList(title: AppLoacalize.textString.camera, description: AppLoacalize.textString.cameraDesc, image: Image.imageString.camera),
            
            PermissionList(title: AppLoacalize.textString.storage, description: AppLoacalize.textString.storageDesc, image: Image.imageString.storage),
            
            PermissionList(title: AppLoacalize.textString.sms, description: AppLoacalize.textString.smsDesc, image: Image.imageString.sms),
            
            PermissionList(title: AppLoacalize.textString.location, description: AppLoacalize.textString.locationDesc, image: Image.imageString.location)]
        
        let response = Permission.FetchList.Response(permissionList: permissionArr)
        self.presenter?.listPermissionDataResponse(data: response)
    }
    
    /* Check Permission Status */
    func checkPermissionGranted(checkLocationOnce: Bool) {
        var contact: Bool?
        var location: Bool?
        worker?.checkLocationOnce = checkLocationOnce
        worker?.requesLocationPermission { accessGranted in
            location = accessGranted
            self.worker?.requestContactAccess { accessGranted in
                contact = accessGranted
                self.presenter?.sendCheckedPermissionData(data: GrantedPermission(contact: contact, location: location))
            }
            
        }
        
    }
    
    /* Get Location Permission Status */
    func getLocationPermissionStatus() {
        worker?.getLocationPermissionStatus(completionHandler: { status in
            self.presenter?.sendLocationPermissionStatus(status: status)
        })
        
    }
    
    /* Request Permission */
    func requestPermissions() {
        worker?.requesLocationPermission { [weak self] accessGranted in
            if accessGranted {
                self?.requestContact()
            } else {
                self?.updatePermissionRequests(isAllowed: accessGranted, errorMessage: .locationErr)
            }
        }
    }
    
    /* Request Contact */
    func requestContact() {
        worker?.requestContactAccess { [weak self] accessGranted in
            self?.updatePermissionRequests(isAllowed: accessGranted, errorMessage: accessGranted ? .none : .contactErr)
        }
    }
    
    /* Update Permission Requests */
    private func updatePermissionRequests(isAllowed: Bool, errorMessage: PermissionErrorAlert) {
        self.presenter?.presentPermissionUpdates(isAllowed: isAllowed, errorMsg: errorMessage)
    }
}
