//
//  FitmentCertificateInteractor.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import WebKit
@_implementationOnly import ObjectMapper
@_implementationOnly import Alamofire

protocol FitmentCertificateBusinessLogic {
    func getFitmentData(sendEmail: Bool)
    func convertandSavePdfToDevice(webview: WKWebView?)
}

protocol FitmentCertificateDataStore {
    var fitmentCertificateData: FitmentCertificateData? { get set }
}

class FitmentCertificateInteractor: FitmentCertificateBusinessLogic, FitmentCertificateDataStore {
    var presenter: FitmentCertificatePresentationLogic?
    var worker: FitmentCertificateWorker?
    var fitmentCertificateData: FitmentCertificateData?
    
    // MARK: Get Fitment Data
    func getFitmentData(sendEmail: Bool) {
        let parameters: Parameters = [
            "vehicleId": fitmentCertificateData?.vehicleNumber.removeWhitespace() ?? "",
            "email": EMAIL,
            "sendEmail": sendEmail
        ]
        worker?.callfitmentCerticateApi(params: parameters, completion: { response, code in
            if let responseData = response, code == 200 {
                let response = FitmentCertificate.FitmentCertificateModel.Response(fitmentCertificateData: responseData, sendEmail: sendEmail)
                self.presenter?.presentFitmentData(response: response, fitmentData: self.fitmentCertificateData)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        })
    }
    
    /* Convert and Save Pdf To Device */
    func convertandSavePdfToDevice(webview: WKWebView?) {
      FileLocationManager.shared.saveData(pdfView: webview, isReceipt: false)
    }
        
}
