//
//  ResetMpinViewController.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol ResetMpinDisplayLogic: AnyObject {
    func displayValidateNewMpinText(isEmpty: Bool, mpinText: String)
    func displayResetMpinMatchResponse(isMatch: Bool, responseMsg: String, newMpin: String)
    func displayUpdateMpinResponse(response: MPINResponseData?)
}

class ResetMpinViewController: UIViewController, ResetMpinDisplayLogic {
    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var navigationTitleLabel: UILabel?
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var cardView: UIView?
    @IBOutlet private weak var newMpinView: M2PPinView?
    @IBOutlet private weak var reEnterMpinView: M2PPinView?
    @IBOutlet private weak var confirmButton: UIButton?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var enterNewMpinTitleLabel: UILabel?
    @IBOutlet private weak var reEnterMpinTitleLabel: UILabel?
    @IBOutlet private weak var errordescriptionLabel: UILabel?
    var interactor: ResetMpinBusinessLogic?
    var router: (NSObjectProtocol & ResetMpinRoutingLogic & ResetMpinDataPassing)?
    
    private var newMpinText = "$$$$"
    private var reEnterMpinText = "$$$$"
    private var isAllowConform = false
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView?.applyGradient(isVertical: true, colorArray: [.statusBarColor, .appDarkBlueColor])
    }
}

// MARK: Initial Setup
extension ResetMpinViewController {
    
    // MARK: Initialize UI
    private func initializeUI() {
        [titleLabel].forEach {
            $0?.textColor = .primaryColor
            $0?.font = .setCustomFont(name: .regular, size: .x18)
            $0?.text = AppLoacalize.textString.createNewMpin
        }
        [navigationTitleLabel].forEach {
            $0?.textColor = .white
            $0?.font = .setCustomFont(name: .semiBold, size: .x18)
            $0?.text = AppLoacalize.textString.resetMpin
        }
        [cardView].forEach {
            $0?.addLightShadow(radius: 16)
            $0?.backgroundColor = .white
        }
        [enterNewMpinTitleLabel, reEnterMpinTitleLabel].forEach {
            $0?.textColor = .midGreyColor
            $0?.font = .setCustomFont(name: .regular, size: .x14)
        }
        [errordescriptionLabel].forEach {
            $0?.textColor = .redErrorColor
            $0?.font = .setCustomFont(name: .regular, size: .x12)
            $0?.isHidden = true
        }
        self.view.backgroundColor = .whitebackgroundColor
        initializeMpinView()
        enterNewMpinTitleLabel?.text = AppLoacalize.textString.enterNewMpin
        reEnterMpinTitleLabel?.text = AppLoacalize.textString.reEnterMpin
        backButton?.setBackgroundImage(UIImage(named: Image.imageString.roundedBack), for: .normal)
        backButton?.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        confirmButton?.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        enableConfirmBtn(enable: false)
    }
    
    // MARK: MpinView Setup
    private func initializeMpinView() {
        [newMpinView, reEnterMpinView].forEach {
            $0?.fontTextField = UIFont.setCustomFont(name: .regular, size: .x18)
            $0?.isBottomLineTextField = true
            $0?.borderColorTextField = .blusihGryColor
            $0?.borderWidthTextField = 1
            $0?.selectedBorderColorTextField = .blusihGryColor
            $0?.selectedBorderWidthTextField = 1
            $0?.tintColorTextField = .black
            $0?.textColorTextField = .blackTextColor
            $0?.type = .createMpin
        }
        
        newMpinView?.isSecureTextEntry = false
        reEnterMpinView?.isSecureTextEntry = true
        reEnterMpinView?.dismissOnLastEntry = true
        
        newMpinView?.isBackspaceClicked = {
            self.confirmButton?.setPrimaryButtonState(isEnabled: false)
            self.reEnterMpinView?.resetErrorBorder()
        }
        reEnterMpinView?.isBackspaceClicked = {
            self.confirmButton?.setPrimaryButtonState(isEnabled: false)
            self.reEnterMpinView?.resetErrorBorder()
        }
        newMpinView?.moveNextField = {
            _ = self.reEnterMpinView?.becomeFirstResponder()
        }
        self.createMpinViewCallBack()
    }
    
    // MARK: Handle CreateMpinView CallBack
    private func createMpinViewCallBack() {
        newMpinView?.mPinData = { (createMpinText, index) in // Create MPIN Data
            let newIndex = index/1000 - 1
            self.newMpinText = self.replace(oldString: self.newMpinText, newIndex, Character(createMpinText))
            self.interactor?.validateMPinText(newMPinText: self.newMpinText, reEnterMpinText: self.reEnterMpinText)
        }
        reEnterMpinView?.mPinData = { (confirmMpinText, index) in // Confirm MPIN Data
            let newIndex = index/1000 - 1
            self.reEnterMpinText = self.replace(oldString: self.reEnterMpinText, newIndex, Character(confirmMpinText))
            self.interactor?.validateMPinText(newMPinText: self.newMpinText, reEnterMpinText: self.reEnterMpinText)
        }
        
        newMpinView?.mpinEndData = { (createPinendText, index) in // End Action for Create MPIN
            let newIndex = index/1000 - 1
            self.newMpinText = self.replace(oldString: self.newMpinText, newIndex, Character(createPinendText))
            self.interactor?.validateMPinText(newMPinText: self.newMpinText, reEnterMpinText: self.reEnterMpinText)
        }
        reEnterMpinView?.mpinEndData = { (endText, index) in // End Action for Confirm MPIN
            let newIndex = index/1000 - 1
            self.reEnterMpinText = self.replace(oldString: self.reEnterMpinText, newIndex, Character(endText))
            self.interactor?.validateMPinText(newMPinText: self.newMpinText, reEnterMpinText: self.reEnterMpinText)
        }
        newMpinView?.setBecomeFirstResponder = {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                _ = self.newMpinView?.becomeFirstResponder()
            }
        }
        
    }
    
    // MARK: Reset View After Failure
    private func resetTextField() {
        self.newMpinView?.text = ""
        self.reEnterMpinView?.text = ""
        self.newMpinText = "$$$$"
        self.reEnterMpinText = "$$$$"
        self.newMpinView?.setBorder()
        self.reEnterMpinView?.setBorder()
    }
    
    // MARK: Reset View After Failure
    private func resetReEnterTextField() {
        self.reEnterMpinView?.text = ""
        self.reEnterMpinText = "$$$$"
        self.reEnterMpinView?.setBorder()
    }
    
    // MARK: Enable ConfirmBtn logic
    private func enableConfirmBtn(enable: Bool) {
        confirmButton?.setup(title: AppLoacalize.textString.confirm, type: .primary, isEnabled: enable)
    }
    
    // MARK: Replace New Pin
    func replace(oldString: String, _ index: Int, _ newCharacter: Character) -> String {
        var characters = Array(oldString)
        characters[index] = newCharacter
        let modifiedString = String(characters)
        return modifiedString
    }
}

// MARK: Button Actions
extension ResetMpinViewController {
    
    // MARK: BackBtn Action
    @objc private func backBtnAction() {
        self.popToViewController(destination: TabbarViewController.self)
    }
    
    // MARK: ConfirmBtn Action
    @objc private func confirmBtnAction() {
        isAllowConform = true
        interactor?.validateMpinMatch(newMpinText: self.newMpinText, reEnterMpinText: self.reEnterMpinText) // Validate Field
    }
}

// MARK: Display logic
extension ResetMpinViewController {
    
    // MARK: Validate New Mpin
    func displayValidateNewMpinText(isEmpty: Bool, mpinText: String) {
        if isEmpty && (mpinText == self.newMpinText) {
            self.errordescriptionLabel?.text = AppLoacalize.textString.emptyMpinToast
            self.confirmButton?.setPrimaryButtonState(isEnabled: false)
            return
        } else if isEmpty && (mpinText == self.reEnterMpinText) {
            self.errordescriptionLabel?.text = AppLoacalize.textString.reEnterMpin
            self.confirmButton?.setPrimaryButtonState(isEnabled: false)
            return
        } else {
            self.confirmButton?.setPrimaryButtonState(isEnabled: true)
        }
        
        self.errordescriptionLabel?.isHidden = !isEmpty
    }
    
    // MARK: Validate Mpin Match
    func displayResetMpinMatchResponse(isMatch: Bool, responseMsg: String, newMpin: String) {
        if isMatch {
            self.reEnterMpinView?.resetErrorBorder()
            self.confirmButton?.setPrimaryButtonState(isEnabled: true)
            if isAllowConform {
                interactor?.updateMpinText(newMpin: newMpin)
                isAllowConform = false
            }
        } else {
            self.confirmButton?.setPrimaryButtonState(isEnabled: false)
            //            resetReEnterTextField()
            reEnterMpinView?.setErrorBorder()
            showSuccessToastMessage(message: AppLoacalize.textString.mpinMismatch)
        }
    }
    
    // MARK: Updated Mpin Response
    func displayUpdateMpinResponse(response: MPINResponseData?) {
        guard let data = response else {
            showSuccessToastMessage(message: AppLoacalize.textString.somethingWentWrong)
            return
        }
        
        if data.status == APIStatus.statusString.success {
            showSuccessToastMessage(message: AppLoacalize.textString.mpinUpdateSuccess, messageColor: .white, bgColour: .greenTextColor, position: .center, duration: 3.0)
            self.router?.routeToInitialUserFlow()
        } else {
            showSuccessToastMessage(message: data.exception?.detailMessage ?? "")
        }
    }
}
