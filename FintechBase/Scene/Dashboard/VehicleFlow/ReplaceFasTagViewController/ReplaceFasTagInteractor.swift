//
//  ReplaceFasTagInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ReplaceFasTagBusinessLogic {
    func getReplaceTags()
    func appleReplaceCard(reason: String)
    func getVehicleNumber()
}

protocol ReplaceFasTagDataStore {
    var vehileNumber: String { get set }
    // var name: String { get set }
}

class ReplaceFasTagInteractor: ReplaceFasTagBusinessLogic, ReplaceFasTagDataStore {
    var presenter: ReplaceFasTagPresentationLogic?
    var worker: ReplaceFasTagWorker?
    var vehileNumber: String = ""
   
    // MARK: get tag list
    func getReplaceTags() {
        worker?.getTagApi(params: nil, completion: { results, code in
            if let response = results, code == 200 {
                let response = GetFastTag.Tag.Response(replaceTagResultResponse: response)
                self.presenter?.presentTagList(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    // MARK: Replace FastTag
    func appleReplaceCard(reason: String) {
        let requestDict = [
            "mobile": userMobileNumber,
            "reason": reason,
            "name": userName
        ]
        worker?.applyReplaceFastTagApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                let response = ReplaceFastTag.ReplaceTag.Response(replaceTagResultResponse: response)
                self.presenter?.presentApplyFastTag(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    /* Get Vehicle Number */
    func getVehicleNumber() {
        presenter?.presentVehicleNumber(number: self.vehileNumber)
    }
}
