//
//  MobileNumberViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DigiLockerSDK

protocol MobileNumberDisplayLogic: AnyObject {
    func mobileNumberData(response: MobileNumberModel.Customer.ViewModel)
    func displayDigiLockerResponse()
}

class MobileNumberViewController: UIViewController {
    
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var tittleLbl: UILabel?
    @IBOutlet weak var countryCodeTextField: UITextField?
    @IBOutlet weak var mobileNumTextField: UITextField?
    @IBOutlet weak var bottomLineView: UIView?
    @IBOutlet weak var staticDescriptionLbl: UILabel?
    @IBOutlet weak var verifyBttn: UIButton?
    
    var interactor: MobileNumberBusinessLogic?
    var router: (NSObjectProtocol & MobileNumberRoutingLogic & MobileNumberDataPassing)?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.mobileNumTextField?.becomeFirstResponder()
        }
    }
    
}

// MARK: Initial Set Up
extension MobileNumberViewController {
    private func initialLoads() {
        self.navigationController?.isNavigationBarHidden = true
        self.setMobileNumberView()
        self.setButton()
        self.setColor()
        self.setFont()
        self.setStaticText()
        self.mobileNumTextField?.keyboardType = .numberPad
        self.mobileNumTextField?.delegate = self
    }
    
    // MARK: Color
    private func setColor() {
        self.tittleLbl?.textColor = .primaryColor
        self.staticDescriptionLbl?.textColor = .darkGreyDescriptionColor
        self.mobileNumTextField?.textColor = .primaryColor
        self.countryCodeTextField?.textColor = .primaryColor
        self.bottomLineView?.backgroundColor = .blusihGryColor
    }
    
    // MARK: Font
    private func setFont() {
        self.tittleLbl?.font = UIFont.setCustomFont(name: .regular, size: .x24)
        self.staticDescriptionLbl?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        self.mobileNumTextField?.font = UIFont.setCustomFont(name: .regular, size: .x18)
        self.countryCodeTextField?.font = UIFont.setCustomFont(name: .regular, size: .x18)
    }
    
    // MARK: Static Text
    private func setStaticText() {
        self.tittleLbl?.text = AppLoacalize.textString.mobileVCTitle
        self.staticDescriptionLbl?.text = AppLoacalize.textString.mobileVCDescription
        self.countryCodeTextField?.text = AppLoacalize.textString.countryCode
        self.mobileNumTextField?.placeholder = AppLoacalize.textString.mobilePlaceholder
    }
    
    // MARK: Set MobileNumber View
    private func setMobileNumberView() {
        self.mobileNumTextField?.keyboardType = .namePhonePad
        self.countryCodeTextField?.isUserInteractionEnabled = false
    }
    
    // MARK: Set Button
    private func setButton() {
        self.verifyBttn?.setup(title: AppLoacalize.textString.continueText, type: .primary, isEnabled: false)
        self.verifyBttn?.addTarget(self, action: #selector(verifyBttnAction(_:)), for: .touchUpInside)
    }
    
    // MARK: Verify Button Action
    @objc private func verifyBttnAction(_ sender: UIButton) {
        guard let mobileNumber = mobileNumTextField?.text else {
            return
        }
        self.interactor?.mobileNumberData(number: "\(mobileNumber)")
    }
    // MARK: Invoke DigiLock
    func invokeDigiLock() {
        DigiLocker.shared.onSDKCompletion = { isSucces, result in

            if let responseDic = result?.convertToDictionary(type: DigiLockerResponse.self), isSucces {
//                print("====== Results Json ====== \n", responseDic)
                self.interactor?.setDigiLockerResponse(digiLockerResponse: responseDic)
            } else {
                showSuccessToastMessage(message: AppLoacalize.textString.kycFailed, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        }
        
        DigiLocker.shared.apiBaseURL = digiLockBaseURL
        DigiLocker.shared.documentType = DocumentType.aadhar
        DigiLocker.shared.authKey = AUTHKEY
        DigiLocker.shared.present(from: self)
    }
}

// MARK: TextField Delegate methods
extension MobileNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let contentTextfieldCount = mobileNumTextField?.text else {
            return false
        }
        
        if textField == mobileNumTextField {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            let ranges = range.length + range.location > contentTextfieldCount.count
            
            if ranges == false && alphabet == false {
                return false
            }
            let newLength = contentTextfieldCount.count + string.count - range.length
            if newLength >= 10 {
                self.verifyBttn?.setPrimaryButtonState(isEnabled: true)
            } else {
                self.verifyBttn?.setPrimaryButtonState(isEnabled: false)
            }
            return newLength <= 10
        }
        return false
    }
}

// MARK: Display Logic
extension MobileNumberViewController: MobileNumberDisplayLogic {
    /* Display mobileNumber data */
    func mobileNumberData(response: MobileNumberModel.Customer.ViewModel) {
        if response.viewModel?.isAccountClosed == "true" {
            self.router?.routeToRequestSubmittedViewController()
        } else {
            switch response.viewModel?.status {
            case CustomerStatus.success.rawValue:
                self.router?.routeToOTPController(isFromDigiLocker: false)
            case CustomerStatus.failed.rawValue:
                self.router?.routeToOTPController(isFromDigiLocker: false)
            case CustomerStatus.error.rawValue:
                self.router?.routeToOTPController(isFromDigiLocker: true)
            default:
                showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            }
        }
    }
    /* Display Digi Locker Response*/
    func displayDigiLockerResponse() {
        self.router?.routeToAccountDetailsVC(isNewUser: true)
    }
    
}
