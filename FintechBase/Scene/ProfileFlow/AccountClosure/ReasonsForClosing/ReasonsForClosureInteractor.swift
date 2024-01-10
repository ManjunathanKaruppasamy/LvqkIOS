//
//  ReasonsForClosureInteractor.swift
//  FintechBase
//
//  Created by Sravani Madala on 28/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ReasonsForClosureBusinessLogic {
    func fetchClosureReasons()
}

protocol ReasonsForClosureDataStore {
    // var name: String { get set }
}

class ReasonsForClosureInteractor: ReasonsForClosureBusinessLogic, ReasonsForClosureDataStore {
    var presenter: ReasonsForClosurePresentationLogic?
    var worker: ReasonsForClosureWorker?
    
    // MARK: Fetch Closure Reasons
    func fetchClosureReasons() {
        
        worker?.callfetchClosureReasons(params: nil, completion: { results, code in
            if let response = results, code == 200 {
                let response = ReasonsForClosure.ReasonsForClosureModel.Response(closureReasonsModel: response)
                self.presenter?.presentClosureReasons(response: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
}
