//
//  UserConsentViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 23/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UserConsentDisplayLogic: AnyObject {
    func displayRequestedPermission(data: VkycPermission)
}

protocol PassDataToStartVideoKYC: AnyObject {
    func callVkycLink()
}

class UserConsentViewController: UIViewController {
    @IBOutlet private weak var popupView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var closeButton: UIButton?
    @IBOutlet private weak var checkBoxButton: UIButton?
    @IBOutlet private weak var termsLabel: UILabel?
    @IBOutlet private weak var proceedButton: UIButton?
    @IBOutlet private weak var contentTextView: UITextView?
    
    var interactor: UserConsentBusinessLogic?
    var router: (NSObjectProtocol & UserConsentRoutingLogic & UserConsentDataPassing)?
    var proceedTapped: (() -> Void)?
    var delegate: PassDataToStartVideoKYC?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popupView?.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
}

// MARK: Initial Setup
extension UserConsentViewController {
    
    // MARK: Initialize UI
    private func initializeUI() {
        titleLabel?.font = .setCustomFont(name: .regular, size: .x18)
        titleLabel?.textColor = .primaryColor
        titleLabel?.text = AppLoacalize.textString.userConsent
        
        contentTextView?.text = AppLoacalize.textString.userConsentText
        contentTextView?.textColor = .darkBlack
        contentTextView?.font = .setCustomFont(name: .regular, size: .x14)
        
        termsLabel?.font = .setCustomFont(name: .regular, size: .x14)
        termsLabel?.textColor = .darkGray
        termsLabel?.text = AppLoacalize.textString.userConsentTermsText
        
        proceedButton?.setup(title: AppLoacalize.textString.proceed, type: .primary, isEnabled: false)
        
        closeButton?.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        proceedButton?.addTarget(self, action: #selector(proceedButtonAction), for: .touchUpInside)
        checkBoxButton?.addTarget(self, action: #selector(checkBoxButtonAction), for: .touchUpInside)
        checkBoxButton?.tintColor = .clear
    }
}

// MARK: Button Actions
extension UserConsentViewController {
    
    /* Close Button Action */
    @objc private func closeButtonAction() {
        self.dismissVC()
    }
    
    /* Proceed Button Action */
    @objc private func proceedButtonAction() {
        self.delegate?.callVkycLink()
//        interactor?.requestForPermission()
    }
    
    /* CheckBox Button Action */
    @objc private func checkBoxButtonAction() {
        enableTermsAndContionBtn(enable: !(checkBoxButton?.isSelected ?? false))
    }
    
    /* EnableTermsAndContionBtn Action */
    private func enableTermsAndContionBtn(enable: Bool) {
        checkBoxButton?.isSelected = enable
        enable ? checkBoxButton?.setBackgroundImage(UIImage(named: Image.imageString.fillcheckBox), for: .selected) :
        checkBoxButton?.setBackgroundImage(UIImage(named: Image.imageString.checkBox), for: .normal)
        proceedButton?.setPrimaryButtonState(isEnabled: enable)
    }
}

// MARK: Display logic
extension UserConsentViewController: UserConsentDisplayLogic {
   /* Display Requested Permission */
    func displayRequestedPermission(data: VkycPermission) {
        if let cameraAccess = data.camera, let microPhoneAccess = data.microphone, cameraAccess && microPhoneAccess {
            self.delegate?.callVkycLink()
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.enableCameraAndMicrophone)
        }
    }
}
