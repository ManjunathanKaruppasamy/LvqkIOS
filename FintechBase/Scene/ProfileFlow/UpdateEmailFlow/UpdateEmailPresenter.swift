//
//  UpdateEmailPresenter.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UpdateEmailPresentationLogic {
    func presentUpdatedEmailData(response: UpdateEmail.Validate.Response)
    func presentUpdateEmailApiResponse(response: MPINResponseData?)
}

class UpdateEmailPresenter: UpdateEmailPresentationLogic {
  weak var viewController: UpdateEmailDisplayLogic?
  
  // MARK: Present UpdatedEmailData
  func presentUpdatedEmailData(response: UpdateEmail.Validate.Response) {
      let viewModel = UpdateEmail.Validate.ViewModel(isEmailValidation: response.isEmailValidation, responseMsg: response.responseMsg, email: response.email)
      viewController?.displayValidateEmailResponse(viewModel: viewModel)
  }
    
    /* Present UpdateEmailApiResponse */
    func presentUpdateEmailApiResponse(response: MPINResponseData?) {
        viewController?.displayUpdateEmailResponse(response: response)
    }
}
