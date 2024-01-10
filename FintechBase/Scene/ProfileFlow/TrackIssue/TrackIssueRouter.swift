//
//  TrackIssueRouter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 07/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol TrackIssueRoutingLogic {
  
}

protocol TrackIssueDataPassing {
  var dataStore: TrackIssueDataStore? { get }
}

class TrackIssueRouter: NSObject, TrackIssueRoutingLogic, TrackIssueDataPassing {
  weak var viewController: TrackIssueViewController?
  var dataStore: TrackIssueDataStore?
}
