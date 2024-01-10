//
//  UserConsentPresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UserConsentPresentationLogic {
  func presentRequestedPermissionAccess(data: VkycPermission)
}

class UserConsentPresenter: UserConsentPresentationLogic {
  weak var viewController: UserConsentDisplayLogic?
  
  // MARK: Present Requested PermissionAccess
    func presentRequestedPermissionAccess(data: VkycPermission) {
        viewController?.displayRequestedPermission(data: data)
    }
}
