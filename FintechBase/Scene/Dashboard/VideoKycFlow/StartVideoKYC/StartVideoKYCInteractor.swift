//
//  StartVideoKYCInteractor.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartVideoKYCBusinessLogic {
    func getUIContentList()
    func fetchVKYCLink()
    func getUserData()
}

protocol StartVideoKYCDataStore {
    var flowEnum: ModuleFlowEnum? { get set }
    var vkycLink: String? { get set }
}

class StartVideoKYCInteractor: StartVideoKYCBusinessLogic, StartVideoKYCDataStore {
    var presenter: StartVideoKYCPresentationLogic?
    var worker: StartVideoKYCWorker?
    var flowEnum: ModuleFlowEnum?
    var vkycLink: String?
    
    // MARK: Get UI ContentList
    func getUIContentList() {
        presenter?.presentNotesList(list: self.loadNotesList(), flowEnum: self.flowEnum ?? .none)
    }
    
    /* Load NotesList */
    private func loadNotesList() -> [NotesListModel] {
        let valueOne = NotesListModel(titleMessage: AppLoacalize.textString.vkycNote1, id: 1)
        let valueTwo = NotesListModel(titleMessage: AppLoacalize.textString.vkycNote2, id: 2)
//        let valueThree = NotesListModel(titleMessage: AppLoacalize.textString.vkycNote3, id: 3)
        
        return [valueOne, valueTwo]
    }
    
    // MARK: Fetch VKYC Link
    func fetchVKYCLink() {
        let requestDict = [
            "mobile": ENTITYID,
            "corporate": TENANT.uppercased()
        ]
        
        worker?.callVKYCApi(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                let vkycLink = response.result?.vciplink ?? ""
                if  !vkycLink.isEmpty {
                    self.vkycLink = vkycLink
                    self.presenter?.presentVKYCScenes(vkycResponse: response)
                } else {
                    showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
                }
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    
    // MARK: Fetch USER Details for KYC status
    func getUserData() {
       let requestDict = [
        "mobile": userMobileNumber
          ]
        worker?.callFetchCustomer(params: requestDict, completion: { response, code in
            if let responseData = response, code == 200 {
                ENTITYID = responseData.result?.entityid ?? ""
                CORPORATE = responseData.result?.customerType ?? ""
                DOB = response?.result?.dob ?? ""
                userName = response?.result?.name ?? ""
                self.presenter?.presentUserData(response: responseData)
            } else {
                self.presenter?.presentUserData(response: response)
            }
        })
    }
}
