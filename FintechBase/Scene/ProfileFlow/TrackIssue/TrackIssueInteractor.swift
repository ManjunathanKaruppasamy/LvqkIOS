//
//  TrackIssueInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 07/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire

protocol TrackIssueBusinessLogic {
    func loadTrackIssueList()
}

protocol TrackIssueDataStore {
  // var name: String { get set }
}

class TrackIssueInteractor: TrackIssueBusinessLogic, TrackIssueDataStore {
    var presenter: TrackIssuePresentationLogic?
    var worker: TrackIssueWorker?
    // var name: String = ""
    
    // MARK: Load TrackIssueList
    func loadTrackIssueList() {
        let parameters: Parameters = [ "entityId": ENTITYID]
        worker?.callDisputeEntityApi(params: parameters, completion: { result, code in
            if let responseData = result, code == 200 {
                self.presenter?.presentTrackListData(response: responseData.result ?? [DisputeEntityResult]())
            } else {
                self.presenter?.presentTrackListData(response: [DisputeEntityResult]())
            }
        })
    }
}
