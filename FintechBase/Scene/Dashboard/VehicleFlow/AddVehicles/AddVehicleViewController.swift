//
//  AddVehicleViewController.swift
//  FintechBase
//
//  Created by Sravani Madala on 07/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddVehicleDisplayLogic: AnyObject {
    func displayGetFastTagClasses(viewModel: AddVehicle.VehicleFastTagModel.ViewModel)
}

class AddVehicleViewController: UIViewController, UITextFieldDelegate {
    var interactor: AddVehicleBusinessLogic?
    var router: (NSObjectProtocol & AddVehicleRoutingLogic & AddVehicleDataPassing)?
    
    @IBOutlet private weak var verifyButton: UIButton?
    @IBOutlet private weak var regNumberLabel: UILabel?
    @IBOutlet private weak var chasisNumberLabel: UILabel?
    @IBOutlet private weak var titleNameLabel: UILabel?
    @IBOutlet weak var customTextfieldView: CustomFloatingTextField?
    @IBOutlet private weak var qwTagRegButton: UIButton?
    @IBOutlet private weak var qwTagChasisButton: UIButton?
    @IBOutlet private weak var isCommercialLabel: UILabel?
    @IBOutlet private weak var isCommercialYesLabel: UILabel?
    @IBOutlet private weak var isCommercialNoLabel: UILabel?
    @IBOutlet weak var dropDownCustomView: CustomFloatingTextField?
    @IBOutlet private weak var isYesButton: UIButton?
    @IBOutlet private weak var isNoButton: UIButton?
    @IBOutlet private weak var backButton: UIButton?
    
    var didSelectDropDownOption: ((String) -> Void)?
    var dropDownList = ["Car, Jeep, Ven", "Car, Jeep, Ven", "Car, Jeep, Ven"]
    var isCommercialSelected: Bool = true
    var isQWTagSelected: Bool = false
    var isChasisSelected: Bool = false
    
    private var getFastTagClassesList = [FastTagResultList]()
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactorAPICalls()
        initialLoad()
    }
}

// MARK: - Initial Setup
extension AddVehicleViewController {
    private func initialLoad() {
        self.setColor()
        self.setFont()
        self.setButton()
        self.setLoacalise()
        self.setTextFields(title: AppLoacalize.textString.registrationNumber, placeHolder: AppLoacalize.textString.regPlaceHolder, descStr: "")
        self.customTextfieldView?.contentTextfield?.delegate = self
    }
    // MARK: Color
    private func setColor() {
        self.titleNameLabel?.textColor = .textBlackColor
        self.regNumberLabel?.textColor = .textBlackColor
        self.chasisNumberLabel?.textColor = .darkGreyDescriptionColor
        self.isCommercialLabel?.textColor = .midGreyColor
        self.isCommercialYesLabel?.textColor = .textBlackColor
        self.isCommercialNoLabel?.textColor = .textBlackColor
    }
    
    // MARK: Font
    private func setFont() {
        self.titleNameLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.regNumberLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.chasisNumberLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.isCommercialLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.isCommercialYesLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.isCommercialNoLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
    }
    // MARK: set Button
    private func setButton() {
        self.qwTagRegButton?.tag = 1
        self.qwTagChasisButton?.tag = 2
        self.isYesButton?.tag = 3
        self.isNoButton?.tag = 4
        self.isYesButton?.tintColor = .primaryButtonColor
        self.isNoButton?.tintColor = .primaryButtonColor
        self.qwTagRegButton?.tintColor = .primaryButtonColor
        self.qwTagChasisButton?.tintColor = .primaryButtonColor
        self.qwTagRegButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
        self.isNoButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
        self.verifyButton?.setup(title: AppLoacalize.textString.verify, type: .primary, isEnabled: false)
        self.backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        self.verifyButton?.addTarget(self, action: #selector(verifyButtonAction(_:)), for: .touchUpInside)
        self.qwTagRegButton?.addTarget(self, action: #selector(vehicleTagValidationCheck(_:)), for: .touchUpInside)
        self.qwTagChasisButton?.addTarget(self, action: #selector(vehicleTagValidationCheck(_:)), for: .touchUpInside)
        self.isYesButton?.addTarget(self, action: #selector(vehicleTagValidationCheck(_:)), for: .touchUpInside)
        self.isNoButton?.addTarget(self, action: #selector(vehicleTagValidationCheck(_:)), for: .touchUpInside)
        self.setQWVehicleTitles(isChasis: false)
        self.isQWTagSelected = true
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.chasisNumberLabel?.text = AppLoacalize.textString.chasisNumber
        self.regNumberLabel?.text = AppLoacalize.textString.registrationNumber
    }
    
    // MARK: set TextField
    private func setTextFields(title: String, placeHolder: String, descStr: String) {
        
        self.customTextfieldView?.contentTextfield?.titleFont = UIFont.setCustomFont(name: .regular, size: .x12)
        self.customTextfieldView?.contentTextfield?.placeholderFont = UIFont.setCustomFont(name: .regular, size: .x14)
        self.customTextfieldView?.contentTextfield?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        self.customTextfieldView?.contentTextfield?.titleColor = .midGreyColor
        self.customTextfieldView?.contentTextfield?.selectedTitleColor = .textBlackColor
        self.customTextfieldView?.setupField(selectType: .text, title: title, placeHolder: placeHolder)
        var errorContent = ErrorAndDescription()
        errorContent.type = .withDescription
        errorContent.description = descStr
        self.customTextfieldView?.setErrorDescriptionView(errorDescription: errorContent)
        self.customTextfieldView?.contentTextfield?.textColor = .textBlackColor
        self.customTextfieldView?.onClearOptions = {
            self.customTextfieldView?.contentTextfield?.text = ""
        }
    }
    
    // MARK: Setup DropDown
    private func setUpDropdown() {
        self.dropDownCustomView?.contentTextfield?.titleFont = UIFont.setCustomFont(name: .regular, size: .x12)
        self.dropDownCustomView?.contentTextfield?.placeholderFont = UIFont.setCustomFont(name: .regular, size: .x14)
        self.dropDownCustomView?.contentTextfield?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.dropDownCustomView?.contentTextfield?.placeholderColor = .lightDisableBackgroundColor
        self.dropDownCustomView?.contentTextfield?.titleColor = .midGreyColor
        self.dropDownCustomView?.contentTextfield?.selectedTitleColor = .midGreyColor
        self.dropDownCustomView?.contentTextfield?.textColor = .primaryColor
        self.dropDownCustomView?.contentTextfield?.text = "VC4"
        self.dropDownCustomView?.isUserInteractionEnabled = false
        self.dropDownCustomView?.setupField(selectType: .dropDown, title: AppLoacalize.textString.vehicleClassTitle, placeHolder: AppLoacalize.textString.selectVehicleType, drownDropData: DropDownContains(dropDownImageList: getFastTagClassesList, isOnlyTitle: false, parentView: UIApplication.getTopViewController()))
        self.dropDownCustomView?.didSelectDropDownOption = { (selesctedText, index) in
            self.verifyButton?.setPrimaryButtonState(isEnabled: true, primaryButtonSetup: PrimaryButtonSetup(cornerRadius: 4))
            self.didSelectDropDownOption?(selesctedText)
        }
    }
}

// MARK: Button Actions
extension AddVehicleViewController {
    
    // MARK: request call Button Action
    @objc private func verifyButtonAction(_ sender: UIButton) {
        AddVehicleData.sharedInstace.vehicleNumber = self.customTextfieldView?.contentTextfield?.text ?? ""
        AddVehicleData.sharedInstace.isChasis = isChasisSelected
        AddVehicleData.sharedInstace.isCommercial = false
        AddVehicleData.sharedInstace.vehicleClass = self.dropDownCustomView?.contentTextfield?.text ?? ""
        self.router?.routeToVehicleVerificationVC()
    }
    
    // MARK: Back Button Action
    @objc private func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func checkVehicleTag(tag: Int) {
        if tag == 1 {
            self.customTextfieldView?.contentTextfield?.text = ""
            if ((qwTagRegButton?.currentImage?.isEqual(UIImage(named: Image.imageString.radioUnselect))) != nil) {
                self.qwTagRegButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
                self.qwTagChasisButton?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
                self.regNumberLabel?.textColor = .textBlackColor
                self.chasisNumberLabel?.textColor = .darkGreyDescriptionColor
                self.isChasisSelected = false
                self.setQWVehicleTitles(isChasis: false)
            } else {
                self.qwTagRegButton?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
                self.qwTagChasisButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
                self.regNumberLabel?.textColor = .darkGreyDescriptionColor
                self.chasisNumberLabel?.textColor = .textBlackColor
            }
        } else {
            self.customTextfieldView?.contentTextfield?.text = ""
            if ((qwTagChasisButton?.currentImage?.isEqual(UIImage(named: Image.imageString.radioUnselect))) != nil) {
                self.qwTagChasisButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
                self.qwTagRegButton?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
                self.chasisNumberLabel?.textColor = .textBlackColor
                self.regNumberLabel?.textColor = .darkGreyDescriptionColor
                self.isChasisSelected = true
                self.setQWVehicleTitles(isChasis: true)
            } else {
                self.qwTagChasisButton?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
                self.qwTagChasisButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
                self.chasisNumberLabel?.textColor = .darkGreyDescriptionColor
                self.regNumberLabel?.textColor = .textBlackColor
            }
        }
    }
    
    private func setQWVehicleTitles(isChasis: Bool) {
        if isChasis {
            self.setTextFields(title: AppLoacalize.textString.enterChasisNumber, placeHolder: AppLoacalize.textString.chasisPlaceHolder, descStr: AppLoacalize.textString.chasisErrDescription)
        } else {
            self.setTextFields(title: AppLoacalize.textString.enterRegNumber, placeHolder: AppLoacalize.textString.regPlaceHolder, descStr: AppLoacalize.textString.regErrDescription)
        }
    }
    
    // MARK: QW tag Vehicle select
    
    @objc func checkIsCommercialVehicle(tag: Int) {
        if tag == 3 {
            if((isYesButton?.currentImage?.isEqual(UIImage(named: Image.imageString.radioUnselect))) != nil) {
                self.isYesButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
                self.isNoButton?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
                self.isCommercialYesLabel?.textColor = .textBlackColor
                self.isCommercialNoLabel?.textColor = .darkGreyDescriptionColor
            } else {
                self.isYesButton?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
                self.isNoButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
                self.isCommercialNoLabel?.textColor = .darkGreyDescriptionColor
                self.isCommercialYesLabel?.textColor = .textBlackColor
            }
        } else {
            if ((isNoButton?.currentImage?.isEqual(UIImage(named: Image.imageString.radioUnselect))) != nil) {
                self.isNoButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
                self.isYesButton?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
                self.isCommercialYesLabel?.textColor = .darkGreyDescriptionColor
                self.isCommercialNoLabel?.textColor = .textBlackColor
            } else {
                self.isNoButton?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
                self.isNoButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
                self.isCommercialYesLabel?.textColor = .textBlackColor
                self.isCommercialNoLabel?.textColor = .darkGreyDescriptionColor
            }
        }
    }
    
    // MARK: request call Button Action
    @objc private func vehicleTagValidationCheck(_ sender: UIButton) {
        switch sender.tag {
        case 1, 2:
            checkVehicleTag(tag: sender.tag)
            isQWTagSelected = true
            validationVerifyButton(QWNumberCheck:  self.customTextfieldView?.contentTextfield?.text?.isEmpty ?? true)
        case 3, 4:
            isCommercialSelected = true
            checkIsCommercialVehicle(tag: sender.tag)
            validationVerifyButton(QWNumberCheck: self.customTextfieldView?.contentTextfield?.text?.isEmpty ?? true)
        default:
            break
        }
    }
    
    // MARK: Validation For verify button
    private func validationVerifyButton(QWNumberCheck: Bool) {
        if !QWNumberCheck && isQWTagSelected && isCommercialSelected {
            self.verifyButton?.setup(title: AppLoacalize.textString.verify, type: .primary, isEnabled: true)
        } else {
            self.verifyButton?.setup(title: AppLoacalize.textString.verify, type: .primary, isEnabled: false)
        }
    }
}

// MARK: Textfield delegates
extension AddVehicleViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else {
            validationVerifyButton(QWNumberCheck: true)
            return true
        }
        validationVerifyButton(QWNumberCheck: false)
        return true
    }
}

// MARK: - Interactor requests45
extension AddVehicleViewController {
    func interactorAPICalls() {
        interactor?.getVehicleClassesData()
    }
}

// MARK: - <AddVehicleDisplayLogic> Methods
extension AddVehicleViewController: AddVehicleDisplayLogic {
    func displayGetFastTagClasses(viewModel: AddVehicle.VehicleFastTagModel.ViewModel) {
        if let fastTagList = viewModel.getFastTagVehicleModel?.result {
            self.getFastTagClassesList = fastTagList
            self.setUpDropdown()
        }
    }
}
