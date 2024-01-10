//
//  UserConsentInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UserConsentBusinessLogic {
  func requestForPermission()
}

protocol UserConsentDataStore {
  // var name: String { get set }
}

class UserConsentInteractor: UserConsentBusinessLogic, UserConsentDataStore {
  var presenter: UserConsentPresentationLogic?
  var worker: UserConsentWorker?
  // var name: String = ""
  
  // MARK: Request For Permission
  func requestForPermission() {
      var camera: Bool?
      var microphone: Bool?
      worker?.requestCameraAccess(completionHandler: { isGranted in
          camera = isGranted
          self.worker?.requestMicroPhoneAccess(completionHandler: { isGranted in
             microphone = isGranted
              self.presenter?.presentRequestedPermissionAccess(data: VkycPermission(camera: camera, microphone: microphone))
          })
      })
  }
}
