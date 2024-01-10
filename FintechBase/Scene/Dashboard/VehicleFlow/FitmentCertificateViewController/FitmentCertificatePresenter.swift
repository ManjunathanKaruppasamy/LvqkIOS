//
//  FitmentCertificatePresenter.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FitmentCertificatePresentationLogic {
    func presentFitmentData(response: FitmentCertificate.FitmentCertificateModel.Response, fitmentData: FitmentCertificateData?)
}

class FitmentCertificatePresenter: FitmentCertificatePresentationLogic {
  weak var viewController: FitmentCertificateDisplayLogic?
  
  // MARK: Present Fitment Data
  func presentFitmentData(response: FitmentCertificate.FitmentCertificateModel.Response, fitmentData: FitmentCertificateData?) {
      let viewModel = FitmentCertificate.FitmentCertificateModel.ViewModel(fitmentCertificateData: response.fitmentCertificateData, sendEmail: response.sendEmail)
      viewController?.displayFitmentData(viewModel: viewModel, fitmentData: fitmentData)
  }
    
    func presentShareSheet(path: URL) {
        
    }
}
