//
//  UpdateEmailViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 09/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UpdateEmailDisplayLogic: AnyObject {
  func displayValidateEmailResponse(viewModel: UpdateEmail.Validate.ViewModel)
  func displayUpdateEmailResponse(response: MPINResponseData?)
}

class UpdateEmailViewController: UIViewController {
    @IBOutlet private weak var navigationTitleLabel: UILabel?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var newEmailTFView: CustomFloatingTextField?
    @IBOutlet private weak var confirmEmailTFView: CustomFloatingTextField?
    @IBOutlet private weak var confirmButton: UIButton?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var cardView: UIView?
    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var statusBarView: UIView?
    var isBackButtonTapped = false
    var interactor: UpdateEmailBusinessLogic?
    var router: (NSObjectProtocol & UpdateEmailRoutingLogic & UpdateEmailDataPassing)?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationView?.applyGradient(isVertical: true, colorArray: [.statusBarColor, .appDarkBlueColor])
    }
}

// MARK: Initial Setup
extension UpdateEmailViewController {
    
    // MARK: Initialize UI
    private func initializeUI() {
        [navigationTitleLabel].forEach {
            $0?.textColor = .white
            $0?.font = .setCustomFont(name: .semiBold, size: .x18)
            $0?.text = AppLoacalize.textString.emailSettings
        }
        [titleLabel].forEach {
            $0?.textColor = .primaryColor
            $0?.font = .setCustomFont(name: .regular, size: .x18)
            $0?.text = AppLoacalize.textString.changeEmailID
        }
        
        [newEmailTFView].forEach {
            $0?.setupField(selectType: .text, title: AppLoacalize.textString.enterEmailID, placeHolder: AppLoacalize.textString.emailPlaceholder)
            $0?.contentTextfield?.textColor = .primaryColor
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.newEmailTFView?.contentTextfield?.becomeFirstResponder()
            }
        }
        
        [confirmEmailTFView].forEach {
            $0?.setupField(selectType: .text, title: AppLoacalize.textString.reEnterEmailID, placeHolder: AppLoacalize.textString.secureEntryPlaceholder)
            $0?.contentTextfield?.textColor = .primaryColor
            $0?.contentTextfield?.isSecureTextEntry = true
        }
        
        [cardView].forEach {
            $0?.addLightShadow(radius: 16)
            $0?.backgroundColor = .white
        }
        
        [confirmButton].forEach {
            $0?.setup(title: AppLoacalize.textString.confirm, type: .primary, isEnabled: false)
            $0?.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        }
        
        statusBarView?.backgroundColor = .statusBarColor
        backButton?.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        self.view.backgroundColor = .whitebackgroundColor
        
        confirmEmailTFView?.checkTextField = { text in
            self.validateConfirmButtonAction(emailString: text)
        }
        
        newEmailTFView?.checkTextField = { text in
            self.validateConfirmButtonAction(emailString: text)
        }

        [newEmailTFView, confirmEmailTFView].forEach {
            let type = $0 == newEmailTFView ? newEmailTFView : confirmEmailTFView
            $0?.checkAtEndEdit = { isEnd in
                if isEnd {
                    self.getValidEmail(field: type)
                }
            }
        }
    }
}

// MARK: Button actions
extension UpdateEmailViewController {
   
    // MARK: Back actions
    @objc private func backBtnAction() {
        self.isBackButtonTapped = true
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: Validate Confirm Button
    private func validateConfirmButtonAction(emailString: String) {
        guard let newMail = newEmailTFView?.contentTextfield?.text, newMail.isValidEmail() else { confirmButton?.setPrimaryButtonState(isEnabled: false)
            return }
        
        guard let reEnterMail = confirmEmailTFView?.contentTextfield?.text, reEnterMail.isValidEmail() && newMail.count <= reEnterMail.count else { confirmButton?.setPrimaryButtonState(isEnabled: false)
            return }
        
        if newMail == reEnterMail {
            let request = UpdateEmail.Validate.Request(newEmailID: newEmailTFView?.contentTextfield?.text ?? "", reEnteredEmailID: confirmEmailTFView?.contentTextfield?.text ?? "")
            interactor?.validateEmailCheck(request: request)
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.emailMismatch)
            confirmButton?.setPrimaryButtonState(isEnabled: false)
        }
    }
    
    // MARK: Confirm Action
    @objc private func confirmBtnAction() {
        self.router?.routeToVerifyOtpVC()
//        self.interactor?.getUpdateEmailApiResponse(email: confirmEmailTFView?.contentTextfield?.text ?? "")
    }
    
    /* Get Valid Email */
    private func getValidEmail(field: CustomFloatingTextField?) {
        guard !self.isBackButtonTapped else {
            return
        }
        guard let text = field?.contentTextfield?.text, !text.isEmpty else {
           showSuccessToastMessage(message: AppLoacalize.textString.emailEmpty)
           return
        }
        
        guard text.isValidEmail() else {
            showSuccessToastMessage(message: AppLoacalize.textString.invalidEmail)
            return
         }
    }
}

// MARK: Interactor Requests
extension UpdateEmailViewController {
    // MARK: Check validate Email
    private func checkValidateEmail() {
        let request = UpdateEmail.Validate.Request(newEmailID: newEmailTFView?.contentTextfield?.text, reEnteredEmailID: confirmEmailTFView?.contentTextfield?.text)
        interactor?.validateEmailCheck(request: request)
    }
}

// MARK: Display logic
extension UpdateEmailViewController: UpdateEmailDisplayLogic {
    
    // MARK: Display ValidateEmailResponse data
    func displayValidateEmailResponse(viewModel: UpdateEmail.Validate.ViewModel) {
        let isValid = viewModel.isEmailValidation ?? false
        
        if !isValid {
            showSuccessToastMessage(message: AppLoacalize.textString.emailMismatch)
        }
        confirmButton?.setPrimaryButtonState(isEnabled: isValid)
    }
    
    /* Display UpdateEmailApi Response */
    func displayUpdateEmailResponse(response: MPINResponseData?) {
        if let responseData = response, responseData.status == APIStatus.statusString.success {
            showSuccessToastMessage(message: AppLoacalize.textString.emailUpdateSuccess, messageColor: .white, bgColour: .greenTextColor, position: .betweenBottomAndCenter)
            self.popToViewController(destination: TabbarViewController.self)
        } else {
            showSuccessToastMessage(message: response?.status ?? AppLoacalize.textString.somethingWentWrong)
        }
    }
}
