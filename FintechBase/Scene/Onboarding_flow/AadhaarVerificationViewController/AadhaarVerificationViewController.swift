//
//  AadhaarVerificationViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/11/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AadhaarVerificationDisplayLogic: AnyObject {
    func displaySomething(viewModel: AadhaarVerification.Something.ViewModel)
}

class AadhaarVerificationViewController: UIViewController {
    var interactor: AadhaarVerificationBusinessLogic?
    var router: (NSObjectProtocol & AadhaarVerificationRoutingLogic & AadhaarVerificationDataPassing)?
    
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var aadhaarVerificationImage: UIImageView?
    @IBOutlet weak var descriptionPointOneLabel: UILabel?
    @IBOutlet weak var descriptionPointTwoLabel: UILabel?
    @IBOutlet weak var startVerificationButton: UIButton?
    @IBOutlet private weak var cancelButton: UIButton?
    
    var onClickButton: (() -> Void)?
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
}

// MARK: - Initial Setup
extension AadhaarVerificationViewController {
    private func initialLoad() {

    }
}

// MARK: Initial Set Up
extension AadhaarVerificationViewController {
    func initialLoads() {
        self.setButton()
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.titleLabel?.text = AppLoacalize.textString.verifyYourIdentity
        self.descriptionLabel?.text = AppLoacalize.textString.verifyYourIdentityDescription
        self.descriptionPointOneLabel?.text = AppLoacalize.textString.verifyYourIdentityDescriptionOne
        self.descriptionPointTwoLabel?.text = AppLoacalize.textString.verifyYourIdentityDescriptionTwo
        
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = .setCustomFont(name: .regular, size: .x24)
        self.descriptionLabel?.font = .setCustomFont(name: .regular, size: .x14)
        self.descriptionPointOneLabel?.font = .setCustomFont(name: .regular, size: .x14)
        self.descriptionPointTwoLabel?.font = .setCustomFont(name: .regular, size: .x14)
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryColor
        self.descriptionLabel?.textColor = .textBlackColor
        self.descriptionPointOneLabel?.textColor = .textBlackColor
        self.descriptionPointTwoLabel?.textColor = .textBlackColor
        
    }
    // MARK: set Button
    private func setButton() {
        self.startVerificationButton?.setup(title: AppLoacalize.textString.startVerification, type: .primary, isEnabled: true)
        self.startVerificationButton?.addTarget(self, action: #selector(startVerificationButtonAction(_:)), for: .touchUpInside)
        self.cancelButton?.setup(title: AppLoacalize.textString.cancel, type: .skip, isEnabled: true)
        self.cancelButton?.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: SginIn Button Action
    @objc private func startVerificationButtonAction(_ sender: UIButton) {
        self.onClickButton?()
    }
    
    // MARK: Set Button Action
    @objc private func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - Interactor requests
extension AadhaarVerificationViewController {
    func doSomething() {
        let request = AadhaarVerification.Something.Request()
        interactor?.doSomething(request: request)
    }
}

// MARK: - <AadhaarVerificationDisplayLogic> Methods
extension AadhaarVerificationViewController: AadhaarVerificationDisplayLogic {
    func displaySomething(viewModel: AadhaarVerification.Something.ViewModel) {
        // nameTextField.text = viewModel.name
    }
}
