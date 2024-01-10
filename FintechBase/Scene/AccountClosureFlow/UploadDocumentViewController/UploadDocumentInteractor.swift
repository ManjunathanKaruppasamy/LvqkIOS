//
//  UploadDocumentInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UploadDocumentBusinessLogic {
    func getFieldDetails()
}

protocol UploadDocumentDataStore {
    // var name: String { get set }
}

class UploadDocumentInteractor: UploadDocumentBusinessLogic, UploadDocumentDataStore {
    var presenter: UploadDocumentPresentationLogic?
    var worker: UploadDocumentWorker?
    // var name: String = ""
    
    // MARK: Get Field Details
    func getFieldDetails() {
        let chequePassbook = ["Cheque copy", "Bank passbook"]
        let proof = ["Aadhar Card", "Pan Card", "Voter ID", "Driving License", "Passport"]
        var documentDetailsField = [DocumentDetailsField]()
        if isMinKYC {
            documentDetailsField = [DocumentDetailsField(title: AppLoacalize.textString.cancelledChequeBankpassbook, isFieldRequired: true, dropDownArray: chequePassbook),
                                    DocumentDetailsField(title: AppLoacalize.textString.idProof, isFieldRequired: true, dropDownArray: proof, uploadDocumentTitle: "Front"),
                                    DocumentDetailsField(isFieldRequired: true, isTextFieldHide: true, isTextFieldDepend: true, uploadDocumentTitle: "Back"),
                                    DocumentDetailsField(title: AppLoacalize.textString.addressProof, isFieldRequired: true, dropDownArray: proof, uploadDocumentTitle: "Front"),
                                    DocumentDetailsField(isFieldRequired: true, isTextFieldHide: true, isTextFieldDepend: true, uploadDocumentTitle: "Back") ]
        } else {
            documentDetailsField = [DocumentDetailsField(title: AppLoacalize.textString.cancelledChequeBankpassbook, isFieldRequired: true, dropDownArray: chequePassbook)]
        }
        
        self.presenter?.presentFieldDetails(documentDetailsField: documentDetailsField)
    }
}
