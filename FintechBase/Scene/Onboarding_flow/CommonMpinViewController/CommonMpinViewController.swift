//
//  CommonMpinViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol CommonMpinDisplayLogic: AnyObject {
    func displayLoginMpinResponse(viewModel: CommonMpin.CommonMpinModels.ViewModel)
    func displayMPINResponse(viewModel: CommonMpin.CommonMpinModels.ViewModel)
    func commonMpinData(isSuccess: Bool, enteredPin: String)
    func getValidateStatus(isEmpty: Bool)
    func getCreatConfirmEmptyStatus(isEmpty: Bool, field: String)
    func getCreatConfirmMatchData(isMatch: Bool)
    func getInitialSetUpData(mpinInitialData: MpinInitialData)
    func displayUserData(response: AccountDetailsRespone?)
    func updateCount(totalTime: String)
    //    func setBottomSheet(property: BottomSheetModel?)
}

class CommonMpinViewController: UIViewController {
    var interactor: CommonMpinBusinessLogic?
    var router: (NSObjectProtocol & CommonMpinRoutingLogic & CommonMpinDataPassing)?
    
    @IBOutlet weak var errorCreateConfirmLbl: UILabel?
    @IBOutlet weak var errorCreateConfirmView: UIView?
    @IBOutlet weak var errorEnterMpinLbl: UILabel?
    @IBOutlet weak var errorEnterMpinView: UIView?
    @IBOutlet weak var changeMpinBttnView: UIView?
    @IBOutlet weak var changeMpinBttn: UIButton?
    @IBOutlet weak var closeBtn: UIButton?
    @IBOutlet weak var staticConfirmPinLbl: UILabel?
    @IBOutlet weak var staticCreatePinLbl: UILabel?
    @IBOutlet weak var createMpinView: M2PPinView?
    @IBOutlet weak var confirmMpinView: M2PPinView?
    @IBOutlet weak var createMpinContentView: UIView?
    @IBOutlet weak var enterOldMpinLbl: UILabel?
    @IBOutlet weak var forgotMpinBttn: UIButton?
    @IBOutlet weak var enterMpinView: M2PPinView?
    @IBOutlet weak var enterMpinContentView: UIView?
    @IBOutlet weak var descriptionLbl: UILabel?
    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var cancelButton: UIButton?
    
    var onCompletePin:(() -> Void)?
    var onClickResetPin:(() -> Void)?
    var type: MpinType = .changeMpin
    var isChangePinMatched = false
    var retryCount = 3
    var createMpinText = "$$$$"
    var confirmMpinText = "$$$$"
    var enterMpinText = "$$$$"
    var loaderView = LoaderView()
    var successFailurePopUpView = SuccessFailurePopUpView()
    var isFromForgot: Bool = false
    var isAllowConform = false
    var isFromDOB = false
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.interactor?.stopMpinTimer()
    }
}

// MARK: Initial Set Up
extension CommonMpinViewController {
    // MARK: Initial Loads
    func initialLoads() {
        self.setLoacalise()
        self.setColor()
        self.setFont()
        self.setButton()
        self.errorEnterMpinView?.isHidden = true
        self.errorCreateConfirmView?.isHidden = true
        
        self.navigationController?.isNavigationBarHidden = true
        self.interactor?.getInitialSetUpData()
        if self.type == .enterMpin {
            if biometricEnabled && !isFromDOB {
//                self.router?.routeToBiometricVC(setMPINView: .verifyMPIN)
                self.changeMpinBttn?.isHidden = false
            } else {
                self.changeMpinBttn?.isHidden = true
            }
        }
    }
    
    // MARK: Set Up Mpin View
    private func setUpMpinView(type: MpinType) {
        if type == .enterMpin {
            self.titleLbl?.text = "Hi, \(userName.capitalized)"
            self.descriptionLbl?.text = AppLoacalize.textString.welcomeBack
            self.forgotMpinBttn?.setup(title: "\(AppLoacalize.textString.forgotMPIN)?", type: .skip, isEnabled: true)
            self.enterOldMpinLbl?.isHidden = false
            self.createMpinContentView?.isHidden = true
            self.changeMpinBttnView?.isHidden = false
            self.cancelButton?.isHidden = true
            self.changeMpinBttn?.setup(title: AppLoacalize.textString.useBiometric, type: .skip, isEnabled: true)
            if isFromDOB {
                self.forgotMpinBttn?.isHidden = true
                self.descriptionLbl?.isHidden = true
                self.changeMpinBttnView?.isHidden = true
            }
        } else if type == .createMpin {
            if self.isFromForgot {
                self.descriptionLbl?.text = AppLoacalize.textString.forgotDescription
                self.changeMpinBttn?.setup(title: AppLoacalize.textString.submit, type: .primary, isEnabled: false)
                self.cancelButton?.isHidden = false
            } else {
                self.descriptionLbl?.text = AppLoacalize.textString.setMPINDescription
                self.changeMpinBttn?.setup(title: AppLoacalize.textString.confirm, type: .primary, isEnabled: false)
                self.cancelButton?.isHidden = true
            }
            
            self.titleLbl?.text = self.isFromForgot ? AppLoacalize.textString.setNewMpin : AppLoacalize.textString.setMPIN
            self.staticCreatePinLbl?.text = self.isFromForgot ? AppLoacalize.textString.enterNewMpin : AppLoacalize.textString.enterMPIN
            self.errorCreateConfirmLbl?.text = AppLoacalize.textString.mpinMismatch
            self.enterMpinContentView?.isHidden = true
            self.changeMpinBttnView?.isHidden = false
            
        } else if type == .changeMpin {
            self.changeMpinBttnView?.isHidden = false
            self.cancelButton?.isHidden = true
            self.descriptionLbl?.text = AppLoacalize.textString.setMPIN
            self.changeMpinBttn?.setPrimaryButtonState(isEnabled: false)
            self.createMpinView?.isUserInteractionEnabled = false
            self.confirmMpinView?.isUserInteractionEnabled = false
        }
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.staticConfirmPinLbl?.text = AppLoacalize.textString.reEnterMpin
        self.staticCreatePinLbl?.text = AppLoacalize.textString.enterMPIN
        self.titleLbl?.text = AppLoacalize.textString.setMPIN
        self.descriptionLbl?.text = AppLoacalize.textString.setMPINDescription
        self.enterOldMpinLbl?.text = AppLoacalize.textString.enterFourDigitMPIN
        self.forgotMpinBttn?.setTitle("", for: .normal)
    }
    
    // MARK: Color
    private func setColor() {
        [staticConfirmPinLbl, staticCreatePinLbl].forEach {
            $0?.textColor = .midGreyColor
        }
        titleLbl?.textColor = .primaryColor
        descriptionLbl?.textColor = .darkGreyDescriptionColor
        enterOldMpinLbl?.textColor = .darkGreyDescriptionColor
        errorCreateConfirmLbl?.textColor = .redErrorColor
        errorEnterMpinLbl?.textColor = .redErrorColor
        forgotMpinBttn?.setTitleColor(.primaryColor, for: .normal)
        enterMpinView?.tintColorTextField = .black
        enterMpinView?.textColorTextField = .blackTextColor
        enterMpinView?.selectedBorderColorTextField = .blusihGryColor
        enterMpinView?.borderColorTextField = .blusihGryColor
    }
    
    // MARK: Font
    private func setFont() {
        [staticCreatePinLbl, staticConfirmPinLbl, enterOldMpinLbl].forEach {
            $0?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        }
        titleLbl?.font = UIFont.setCustomFont(name: .regular, size: .x24)
        descriptionLbl?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        createMpinView?.fontTextField = UIFont.setCustomFont(name: .regular, size: .x18)
        confirmMpinView?.fontTextField = UIFont.setCustomFont(name: .bold, size: .x32)
        enterMpinView?.fontTextField = UIFont.setCustomFont(name: .regular, size: .x18)
        errorCreateConfirmLbl?.font = UIFont.setCustomFont(name: .regular, size: .x10)
        errorEnterMpinLbl?.font = UIFont.setCustomFont(name: .regular, size: .x10)
    }
    
    // MARK: Set Button
    private func setButton() {
        changeMpinBttn?.setup(title: AppLoacalize.textString.confirm, type: .primary, isEnabled: true)
        self.changeMpinBttn?.addTarget(self, action: #selector(changeMpinAction(_:)), for: .touchUpInside)
        self.forgotMpinBttn?.addTarget(self, action: #selector(forgotMpinAction(_:)), for: .touchUpInside)
        self.closeBtn?.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        self.cancelButton?.setup(title: AppLoacalize.textString.cancel, type: .skip, skipButtonFont: UIFont.setCustomFont(name: .regular, size: .x16))
        self.cancelButton?.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: Cancel Button Action
    @objc private func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Present Loader View
    func presentLoaderView() {
        self.loaderView = LoaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(loaderView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            self.loaderView.removeFromSuperview()
        }
    }
    
    // MARK: Present SuccessFailure PopUp View
    func presentSuccessFailurePopUpView() {
        self.successFailurePopUpView = SuccessFailurePopUpView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.mpinUpdatedSuccessfully,
                                                                                  description: AppLoacalize.textString.mpinUpdateddescription,
                                                                                  image: Image.imageString.successTick,
                                                                                  primaryButtonTitle: AppLoacalize.textString.backToLogin,
                                                                                  isCloseButton: false))
        self.successFailurePopUpView.onClickClose = { isClose in
            for controller in self.navigationController?.viewControllers ?? [] {
                if controller.isKind(of: CommonMpinViewController.self) {
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
            
        }
        self.view.addSubview(successFailurePopUpView)
        
    }
    
    // MARK: SetUp Create MPIN View
    private func setCreateMpinView() {
        [createMpinView, confirmMpinView].forEach {
            $0?.isBottomLineTextField = true
            $0?.borderColorTextField = .blusihGryColor
            $0?.borderWidthTextField = 1
            $0?.selectedBorderColorTextField = .blusihGryColor
            $0?.selectedBorderWidthTextField = 1
            $0?.tintColorTextField = .black
            $0?.textColorTextField = .blackTextColor
            $0?.type = self.type
        }
        createMpinView?.isSecureTextEntry = false
        confirmMpinView?.isSecureTextEntry = true
        if self.type == .changeMpin {
            confirmMpinView?.dismissOnLastEntry = false
        } else {
            confirmMpinView?.dismissOnLastEntry = true
        }
        
        enterMpinView?.setBecomeFirstResponder = {
            _ = self.type == .createMpin ? self.createMpinView?.becomeFirstResponder() : nil // self.enterMpinView?.becomeFirstResponder()
        }
        
        createMpinView?.isBackspaceClicked = {
            if self.type == .createMpin {
                self.changeMpinBttn?.setPrimaryButtonState(isEnabled: false)
                self.confirmMpinView?.resetErrorBorder()
                self.errorCreateConfirmView?.isHidden = true
            }
        }
        confirmMpinView?.isBackspaceClicked = {
            if self.type == .createMpin {
                self.changeMpinBttn?.setPrimaryButtonState(isEnabled: false)
                self.confirmMpinView?.resetErrorBorder()
                self.errorCreateConfirmView?.isHidden = true
            }
        }
        createMpinView?.moveNextField = {
            _ = self.confirmMpinView?.becomeFirstResponder()
            self.interactor?.getValidateCreatePin(createMpinString: self.createMpinText, confirmMpinString: self.confirmMpinText)
        }
        
        confirmMpinView?.moveNextField = {
            self.interactor?.getValidateCreatePin(createMpinString: self.createMpinText, confirmMpinString: self.confirmMpinText)
        }
        self.createMpinViewCallBack()
    }
    
    /* MpinView Call Backs */
    private func createMpinViewCallBack() {
        createMpinView?.mPinData = { (createMpinText, index) in // Create MPIN Data
            let newIndex = index/1000 - 1
            self.createMpinText = self.replace(oldString: self.createMpinText, newIndex, Character(createMpinText))
            self.interactor?.getValidateCreatePin(createMpinString: self.createMpinText, confirmMpinString: self.confirmMpinText)
//            self.errorCreateConfirmView?.isHidden = self.createMpinText == "$$$$" ? false : true
        }
        confirmMpinView?.mPinData = { (confirmMpinText, index) in // Confirm MPIN Data
            let newIndex = index/1000 - 1
            self.confirmMpinText = self.replace(oldString: self.confirmMpinText, newIndex, Character(confirmMpinText))
            self.interactor?.getValidateCreatePin(createMpinString: self.createMpinText, confirmMpinString: self.confirmMpinText)
        }
        createMpinView?.mpinEndData = { (createPinendText, index) in // End Action for Create MPIN
            let newIndex = index/1000 - 1
            self.createMpinText = self.replace(oldString: self.createMpinText, newIndex, Character(createPinendText))
            self.interactor?.getValidateCreatePin(createMpinString: self.createMpinText, confirmMpinString: self.confirmMpinText)
        }
        confirmMpinView?.mpinEndData = { (endText, index) in // End Action for Confirm MPIN
            let newIndex = index/1000 - 1
            self.confirmMpinText = self.replace(oldString: self.confirmMpinText, newIndex, Character(endText))
            self.interactor?.getValidateCreatePin(createMpinString: self.createMpinText, confirmMpinString: self.confirmMpinText)
        }
    }
    
    // MARK: SetUp Enter MPIN View
    private func setEnterMpinView() {
        enterMpinView?.dismissOnLastEntry = true
        enterMpinView?.isBottomLineTextField = true
        enterMpinView?.isSecureTextEntry = true
        enterMpinView?.borderWidthTextField = 1
        enterMpinView?.selectedBorderWidthTextField = 1
        enterMpinView?.setBecomeFirstResponder = {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                if  self.type == .createMpin {
                   _ = self.createMpinView?.becomeFirstResponder()
                } else if  self.type == .enterMpin && (!biometricEnabled || self.isFromDOB) {
                   _ =  self.enterMpinView?.becomeFirstResponder()
                }
            }
//        }
        enterMpinView?.isBackspaceClicked = {
            self.enterMpinView?.resetErrorBorder()
        }
        enterMpinView?.mPinData = { (enterMpinText, index) in // Enter MPIN Data
            let newIndex = index/1000 - 1
            self.enterMpinText = self.replace(oldString: self.enterMpinText, newIndex, Character(enterMpinText))
            self.interactor?.getValidateEmptyField(validateString: self.enterMpinText)
        }
        enterMpinView?.mpinEndData = { (endText, index) in  // End Action
            let newIndex = index/1000 - 1
            self.enterMpinText = self.replace(oldString: self.enterMpinText, newIndex, Character(endText))
            _ = self.enterMpinView?.resignFirstResponder()
//            self.interactor?.getValidateEmptyField(validateString: self.enterMpinText)   // Check Empty Field
        }
    }
    
    // MARK: Close Action
    @objc private func closeTapped() {
        self.dismiss(animated: false)
    }
    
    // MARK: Change Mpin Action
    @objc private func changeMpinAction(_ sender: UIButton) {
        if self.type == .createMpin {
            isAllowConform = true
            self.interactor?.getValidateCreateConfirm(createMpinString: self.createMpinText, confirmMpinString: self.confirmMpinText)
        } else if self.type == .enterMpin {
            self.router?.routeToBiometricVC(setMPINView: .verifyMPIN)
        }
    }
    
    // MARK: Forgot Mpin Action
    @objc private func forgotMpinAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.router?.routeToForgotMPin()
    }
    
    // MARK: Reset View After Failure
    func resetTextField() {
        self.confirmMpinView?.text = ""
        self.createMpinView?.text = ""
        self.createMpinText = "$$$$"
        self.confirmMpinText = "$$$$"
        self.confirmMpinView?.setBorder()
        self.createMpinView?.setBorder()
        self.enterMpinView?.text = ""
        self.enterMpinText = "$$$$"
        self.enterMpinView?.setBorder()
        self.isChangePinMatched = false
        if self.type == .createMpin {
            _ = self.createMpinView?.becomeFirstResponder()
        } else if self.type == .enterMpin {
            if self.retryCount == 0 {
                self.changeMpinBttnView?.isHidden = false
                //                self.enterMpinView?.isUserInteractionEnabled = false
            } else {
                self.changeMpinBttnView?.isHidden = false
            }
        }
    }
    
    /* Reset ConfirmMpinTextField */
    func resetConfirmMpinTextField() {
        self.confirmMpinView?.text = ""
        self.confirmMpinText = "$$$$"
        self.confirmMpinView?.setBorder()
        self.isChangePinMatched = false
        if self.type == .createMpin {
            _ = self.confirmMpinView?.becomeFirstResponder()
        }
    }
    
    // MARK: Replace New Pin
    func replace(oldString: String, _ index: Int, _ newCharacter: Character) -> String {
        var characters = Array(oldString)
        characters[index] = newCharacter
        let modifiedString = String(characters)
        return modifiedString
    }
}

// MARK: Display Logic
extension CommonMpinViewController: CommonMpinDisplayLogic {
    // MARK: Get Initial SetUp Data
    func getInitialSetUpData(mpinInitialData: MpinInitialData) {
        self.type = mpinInitialData.type
        self.isFromDOB = mpinInitialData.isFromDOB
        self.isFromForgot = mpinInitialData.isFromForgot
        self.setCreateMpinView()
        self.setEnterMpinView()
        self.setUpMpinView(type: self.type )
    }
    
    // MARK: Update Timer Count
    func updateCount(totalTime: String) {
        self.errorEnterMpinView?.isHidden = totalTime == "00:00"
        self.enterMpinView?.isUserInteractionEnabled = totalTime == "00:00"
    }
    
    // MARK: Validate Enter MPIN Empty Data
    func getValidateStatus(isEmpty: Bool) {
        if isEmpty {
            //            self.errorEnterMpinView?.isHidden = false
            //            self.errorEnterMpinLbl?.text = "Field is Empty"
            //            self.resetTextField()
            self.enterMpinView?.resetErrorBorder()
            //            return
        } else {
            self.errorEnterMpinView?.isHidden = true
            //            let request = CommonMpin.CommonMpinModels.Request(enteredMpin: self.enterMpinText)    // Check Success/Failure
            //            interactor?.getCommonMpinData(request: request)
            self.interactor?.getMPINLoginResponse(fromBiometric: false, enteredMPIN: self.enterMpinText)
        }
    }
    
    // MARK: Validate Enter MPIN Data
    func commonMpinData(isSuccess: Bool, enteredPin: String) {
        if isSuccess {
            self.errorEnterMpinView?.isHidden = true
            if !(self.type == .changeMpin) {
                //                self.presentLoaderView()
                _ = enterMpinView?.resignFirstResponder()
                self.router?.routeToNextVc()
            } else {
                createMpinView?.isUserInteractionEnabled = true
                _ = self.createMpinView?.becomeFirstResponder()
            }
        } else {
            self.retryCount -= 1
            self.errorEnterMpinView?.isHidden = false
            if self.retryCount == 0 {
                self.retryCount = 3
                //                self.errorEnterMpinLbl?.text = "All Attempts are failed"
                //                self.showMessageAlert(title: "Try again after 60 secs or Reset Pin", message: "", showRetry: true, retryTitle: "OK", showCancel: false, onRetry: {
                // //                    self.enterMpinView?.isUserInteractionEnabled = false
                // //                    self.interactor?.startMpinTimer()
                //                }, onCancel: nil)
            } else {
                self.errorEnterMpinLbl?.text = AppLoacalize.textString.incorrectMPIN
                
                showSuccessToastMessage(message: "Incorrect MPIN.  \(self.retryCount) attempt(s) remaining", messageColor: .white, bgColour: UIColor.redErrorColor)
            }
            self.resetTextField()
        }
    }
    
    // MARK: Validate Create/Confirm MPIN Empty Data
    func getCreatConfirmEmptyStatus(isEmpty: Bool, field: String) {
        if !(self.type == .enterMpin) {
            if isEmpty {
                changeMpinBttn?.setPrimaryButtonState(isEnabled: false)
            } else {
                changeMpinBttn?.setPrimaryButtonState(isEnabled: true)
            }
        }
    }
    
    // MARK: Validate Create/Confirm MPIN Data
    func getCreatConfirmMatchData(isMatch: Bool) {
        if isMatch {
            self.confirmMpinView?.resetErrorBorder()
            self.errorCreateConfirmView?.isHidden = true
            changeMpinBttn?.setPrimaryButtonState(isEnabled: true)
            _ = createMpinView?.resignFirstResponder()
            _ = confirmMpinView?.resignFirstResponder()
            if isAllowConform {
                self.interactor?.getUpdateCustomerApi(mpin: self.confirmMpinText)
                self.isAllowConform = false
            }
        } else {
            self.errorCreateConfirmView?.isHidden = false
            self.errorCreateConfirmLbl?.text = AppLoacalize.textString.mpinMismatch
            changeMpinBttn?.setPrimaryButtonState(isEnabled: false)
            //            self.resetTextField()
            //            resetConfirmMpinTextField()
            confirmMpinView?.setErrorBorder()
        }
    }
    
    // MARK: MPIN API Response
    func displayMPINResponse(viewModel: CommonMpin.CommonMpinModels.ViewModel) {
        if viewModel.mpinViewModelData?.status == APIStatus.statusString.success {
            MPIN = self.confirmMpinText
            if self.isFromForgot {
                self.presentSuccessFailurePopUpView()
            } else {
                self.router?.routeToBiometricVC(setMPINView: .successShowMPIN)
            }
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
        }
    }
    
    // MARK: Login MPIN API Response
    func displayLoginMpinResponse(viewModel: CommonMpin.CommonMpinModels.ViewModel) {
        if viewModel.loginMpinViewModelData?.status == APIStatus.statusString.success {
            self.errorEnterMpinView?.isHidden = true
            if !self.enterMpinText.contains("$") {
                MPIN = self.enterMpinText
            }
            if !(self.type == .changeMpin) {
                _ = enterMpinView?.resignFirstResponder()
                self.interactor?.getUserData()
            } else {
                createMpinView?.isUserInteractionEnabled = true
                _ = self.createMpinView?.becomeFirstResponder()
            }
        } else if viewModel.loginMpinViewModelData?.status == APIStatus.statusString.failed {
            self.errorEnterMpinLbl?.text = AppLoacalize.textString.incorrectMPIN
            
            showSuccessToastMessage(message: viewModel.loginMpinViewModelData?.error ?? AppLoacalize.textString.incorrectMPIN, messageColor: .white, bgColour: UIColor.redErrorColor)
            self.enterMpinView?.setErrorBorder()
        } else if viewModel.loginMpinViewModelData?.status == APIStatus.statusString.error {
            showSuccessToastMessage(message: AppLoacalize.textString.credentialsMismatch, messageColor: .white, bgColour: UIColor.redErrorColor)
            //            resetTextField()
            self.enterMpinView?.setErrorBorder()
        } else {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong, messageColor: .white, bgColour: UIColor.redErrorColor)
            //            resetTextField()
            self.enterMpinView?.setErrorBorder()
        }
    }
    
    /* Display User data */
    func displayUserData(response: AccountDetailsRespone?) {
        self.router?.routeToNextVc()
    }
}
