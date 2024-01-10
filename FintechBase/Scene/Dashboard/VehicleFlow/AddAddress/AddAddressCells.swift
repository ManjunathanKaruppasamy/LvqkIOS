//
//  AddAddressCells.swift
//  FintechBase
//
//  Created by Sravani Madala on 07/08/23.
//

import UIKit

class AddAddressCells: UITableViewCell {

    @IBOutlet weak var customTextfieldView: CustomFloatingTextField?
    
    var isCustomTextFieldData: ((_ text: String, _ tag: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialLoads()
    }
}

// MARK: Initial SetUp
extension AddAddressCells {
    // MARK: Initial Loads
    private func initialLoads() {
        self.customTextfieldView?.contentTextfield?.delegate = self
    }
    
    // MARK: Set Bank Textfield View
    func setUPIIDTextfieldView(title: String, placeholder: String, index: Int) {
        self.customTextfieldView?.contentTextfield?.titleFont = UIFont.setCustomFont(name: .regular, size: .x14)
        self.customTextfieldView?.contentTextfield?.placeholderFont = UIFont.setCustomFont(name: .regular, size: .x14)
        self.customTextfieldView?.contentTextfield?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        if title == AppLoacalize.textString.city || title == AppLoacalize.textString.state {
            self.customTextfieldView?.contentTextfield?.backgroundColor = .lightGreyTextColor
            self.customTextfieldView?.contentTextfield?.addLightShadow()
        }
        self.customTextfieldView?.contentTextfield?.titleColor = .textBlackColor
        self.customTextfieldView?.contentTextfield?.selectedTitleColor = .textBlackColor
        self.customTextfieldView?.setupField(selectType: .text, title: title, placeHolder: placeholder)
        self.customTextfieldView?.contentTextfield?.keyboardType = .emailAddress
        self.customTextfieldView?.contentTextfield?.textColor = .textBlackColor
        self.customTextfieldView?.contentTextfield?.tag = index
        self.customTextfieldView?.onClearOptions = {
            print(index)
        }
        //        self.enterUPIIDTextfieldView?.checkTextField = { text in
        //            self.setUpUPITextField(setUpUPIIDField: .reset)
        //            self.verifyButton?.setPrimaryButtonState(isEnabled: !text.isEmpty ? true : false, primaryButtonSetup: PrimaryButtonSetup(isBlackBG: true))
        //        }
    }
}

// MARK: TextField Delegates
extension AddAddressCells: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.customTextfieldView?.contentTextfield?.keyboardType = .numberPad
        case 1:
            self.customTextfieldView?.contentTextfield?.keyboardType = .numberPad
        case 2:
            self.customTextfieldView?.contentTextfield?.keyboardType = .alphabet
        case 3:
            self.customTextfieldView?.contentTextfield?.keyboardType = .alphabet
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.isCustomTextFieldData?(textField.text ?? "", textField.tag)
        case 1:
            self.isCustomTextFieldData?(textField.text ?? "", textField.tag)
        case 2:
            self.isCustomTextFieldData?(textField.text ?? "", textField.tag)

        case 3:
            self.isCustomTextFieldData?(textField.text ?? "", textField.tag)
        default:
            break
        }
    }
}
