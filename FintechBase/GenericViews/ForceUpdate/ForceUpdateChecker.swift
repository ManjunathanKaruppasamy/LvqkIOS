//
//  ForceUpdateChecker.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/01/24.
//

import Foundation

struct ForceUpdateModel: Codable {
    let forceUpdateRequired: Bool?
    let forceUpdateStoreUrl: String?
    let title: String?
    let description: String?
    let buttonName: String?
    let forceUpdateCurrentVersion: Double?
}
