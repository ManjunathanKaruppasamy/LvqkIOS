//
//  PermissionPresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import CoreLocation

protocol PermissionPresenterLogic {
    func listPermissionDataResponse(data: Permission.FetchList.Response)
    func presentPermissionUpdates(isAllowed: Bool, errorMsg: PermissionErrorAlert)
    func sendCheckedPermissionData(data: GrantedPermission)
    func sendLocationPermissionStatus(status: CLAuthorizationStatus)
}

class PermissionPresenter: PermissionPresenterLogic {
    var viewController: PermissionDisplayLogic?
    
    /* List Permission Data Response */
    func listPermissionDataResponse(data: Permission.FetchList.Response) {
        let viewModel = Permission.FetchList.ViewModel(permissionList: data.permissionList)
        viewController?.listPermissionData(data: viewModel)
    }
    
    /* Present Permission Updates */
    func presentPermissionUpdates(isAllowed: Bool, errorMsg: PermissionErrorAlert) {
        viewController?.displayPermissionUpdates(isAllowed: isAllowed, errorMsg: errorMsg)
    }
    
    /* Present Checked Permission Data*/
    func sendCheckedPermissionData(data: GrantedPermission) {
        self.viewController?.getCheckedPermissionData(data: data)
    }
    
    /* Present Location Permission Status */
    func sendLocationPermissionStatus(status: CLAuthorizationStatus) {
        self.viewController?.getLocationPermissionStatus(status: status)
    }
}
