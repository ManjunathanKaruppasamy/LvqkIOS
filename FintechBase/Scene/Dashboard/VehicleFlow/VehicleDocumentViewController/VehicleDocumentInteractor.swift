//
//  VehicleDocumentInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VehicleDocumentBusinessLogic {
    func getFieldDetails()
    func getAddVehicleData()
}

protocol VehicleDocumentDataStore {
    var isFromChassis: Bool? { get set }
}

class VehicleDocumentInteractor: VehicleDocumentBusinessLogic, VehicleDocumentDataStore {
    var presenter: VehicleDocumentPresentationLogic?
    var worker: VehicleDocumentWorker?
    var isFromChassis: Bool?
    
    // MARK: Get Field Details
    func getFieldDetails() {
        let chequePassbook = ["Insurance", "Invoice copy"]
        var instructionDetailsModel: InstructionDetailsModel?
        var documentDetailsField = [DocumentDetailsField]()
        isFromChassis = AddVehicleData.sharedInstace.isChasis
        if isFromChassis ?? false {
            instructionDetailsModel = InstructionDetailsModel(title: AppLoacalize.textString.pleaseNote, instructionContentArray: ["To register vehicle using the chassis number vehicle should not be older than 120 days.", "if vehicle is older than 120 days will not permitted to register using chassis number."], isTickImageEnable: false)
            if AddVehicleData.sharedInstace.isApplicantExist {
                documentDetailsField = [DocumentDetailsField(title: "Insurance/ Invoice copy", isFieldRequired: true, dropDownArray: chequePassbook, isTextFieldHide: false)]
            } else {
                documentDetailsField = [DocumentDetailsField(isFieldRequired: true, isTextFieldHide: true, uploadDocumentTitle: "Applicant Photograph",
                                                             uploadDocumentDescription: AppLoacalize.textString.ownerDriverPhotograph),
                                        DocumentDetailsField(title: "Insurance/ Invoice copy", isFieldRequired: true, dropDownArray: chequePassbook, isTextFieldHide: false)]
            }
            
        } else {
            let instructionContent = ["Image should be Original RC and not a photo copy ", "Make sure that the text is readable", "Upload image is in JPEG or PNG format"]
            instructionDetailsModel = InstructionDetailsModel(title: AppLoacalize.textString.rcInstructiontitle, instructionContentArray: instructionContent, isTickImageEnable: true)
            if AddVehicleData.sharedInstace.isApplicantExist {
                documentDetailsField = [DocumentDetailsField(isFieldRequired: true, isTextFieldHide: true, uploadDocumentTitle: "Front side of RC"),
                                        DocumentDetailsField(isFieldRequired: true, isTextFieldHide: true, uploadDocumentTitle: "Back side of RC")]
            } else {
                documentDetailsField = [DocumentDetailsField(isFieldRequired: true, isTextFieldHide: true, uploadDocumentTitle: "Applicant Photograph",
                                                             uploadDocumentDescription: AppLoacalize.textString.ownerDriverPhotograph),
                                        DocumentDetailsField(isFieldRequired: true, isTextFieldHide: true, uploadDocumentTitle: "Front side of RC"),
                                        DocumentDetailsField(isFieldRequired: true, isTextFieldHide: true, uploadDocumentTitle: "Back side of RC")]
            }
        }
        
        self.presenter?.presentFieldDetails(documentDetailsField: documentDetailsField, instructionDetailsModel: instructionDetailsModel)
    }
    
    // MARK: fetch vehicle data
    func getAddVehicleData() {
        var requestDict: [String: Any] = [:]
        let idType = AddVehicleData.sharedInstace.isChasis ? "chasis" : "vrn"
        if AddVehicleData.sharedInstace.isChasis {
            requestDict = [
                "entityId": AddVehicleData.sharedInstace.vehicleNumber.removeWhitespace(),
                "idType": idType,
                "parentEntityId": ENTITYID,
                "insurance": AddVehicleData.sharedInstace.insurance,
                "vehicleClass": AddVehicleData.sharedInstace.vehicleClass,
                "isCommercial": AddVehicleData.sharedInstace.isCommercial
            ]
            if !AddVehicleData.sharedInstace.isApplicantExist {
                requestDict["applicantPhoto"] = AddVehicleData.sharedInstace.applicantPhoto
            }
//            print(requestDict)
        } else {
            requestDict = [
               "entityId": AddVehicleData.sharedInstace.vehicleNumber.removeWhitespace(),
               "idType": idType,
               "parentEntityId": ENTITYID,
               "rcFront": AddVehicleData.sharedInstace.rcFront,
               "rcBack": AddVehicleData.sharedInstace.rcBack,
               "vehicleClass": AddVehicleData.sharedInstace.vehicleClass,
               "isCommercial": AddVehicleData.sharedInstace.isCommercial
           ] as [String: Any]
            if !AddVehicleData.sharedInstace.isApplicantExist {
                requestDict["applicantPhoto"] = AddVehicleData.sharedInstace.applicantPhoto

            }
//            print(requestDict)
        }
        worker?.callFetchAddVehicle(params: requestDict, completion: { results, code in
            if let response = results, code == 200 {
                AddVehicleData.sharedInstace.destroy()
                self.presenter?.presentAddVehicleResponse(vehicleResponse: response)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
}
