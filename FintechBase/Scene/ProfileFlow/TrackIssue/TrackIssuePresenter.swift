//
//  TrackIssuePresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 07/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol TrackIssuePresentationLogic {
    func presentTrackListData( response: [DisputeEntityResult])
}

class TrackIssuePresenter: TrackIssuePresentationLogic {
  weak var viewController: TrackIssueDisplayLogic?
  
  // MARK: Present TrackListData
    func presentTrackListData( response: [DisputeEntityResult]) {
        viewController?.displayTrackIssueData(data: response)
    }
}
