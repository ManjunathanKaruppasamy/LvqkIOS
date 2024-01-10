//
//  PermissionModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum PermissionErrorAlert: String {
    case contactErr = "This app requires access to Contacts to proceed. Go to Settings to grant access."
    case locationErr = "This app requires access to Location to proceed. Go to Settings to grant access."
    case none = "none"
}

// swiftlint:disable nesting
enum Permission {
    // MARK: Use cases
    
    enum FetchList {
        struct Request {
        }
        struct Response {
            let permissionList: [PermissionList]?
        }
        struct ViewModel {
            let permissionList: [PermissionList]?
        }
    }
}

struct PermissionList {
    var title: String?
    var description: String?
    var image: String?
}

struct GrantedPermission {
    var contact: Bool?
    var location: Bool?
}
