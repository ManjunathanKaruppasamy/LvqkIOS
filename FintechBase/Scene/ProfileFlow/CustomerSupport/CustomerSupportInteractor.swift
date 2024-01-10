//
//  CustomerSupportInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 06/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CustomerSupportBusinessLogic {
  func loadSupportListData()
}

protocol CustomerSupportDataStore {
  // var name: String { get set }
    var flowEnum: ModuleFlowEnum { get set }
}

class CustomerSupportInteractor: CustomerSupportBusinessLogic, CustomerSupportDataStore {
    var presenter: CustomerSupportPresentationLogic?
    var worker: CustomerSupportWorker?
    var flowEnum: ModuleFlowEnum = .none
    
    // MARK: load TableData
    func loadSupportListData() {
        let value = loadSuportModelListData()
        presenter?.presentSupportListData(response: value, flowEnum: self.flowEnum)
    }
    // MARK: load SuportListData
    private func loadSuportModelListData() -> [CusSupportModel] {
        let value1 = CusSupportModel(name: "If you have any queries", list: [SupportList(img: "phone", title: "Call", clickValue: "18003092225", id: 0), SupportList(img: "mail", title: "Email us at", clickValue: "support@livquik.com", id: 0)], type: "query")
                                                              
        let value2 = CusSupportModel(name: "NHAI , Fastag related issue,", list: [SupportList(img: "phone", title: "Call", clickValue: "1033", id: 0)], type: "fastag")
        return [value1, value2]
    }
}
