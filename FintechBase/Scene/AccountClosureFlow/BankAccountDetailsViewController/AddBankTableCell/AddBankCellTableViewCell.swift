//
//  AddBankCellTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//

import UIKit

class AddBankCellTableViewCell: UITableViewCell {

    @IBOutlet weak var customTextfieldView: CustomFloatingTextField?
    
    var isCustomTextFieldData: ((_ text: String, _ tag: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

// MARK: Initial SetUp
extension AddBankCellTableViewCell {
    
    // MARK: Initial Loads
    private func initialLoads() {
        self.customTextfieldView?.contentTextfield?.delegate = self
    }
    
    // MARK: Set Bank Textfield View
    func setUPIIDTextfieldView(accountDetailsField: AccountDetailsField, index: Int, accountDetailsData: BankAccountDetailsData) {
        self.customTextfieldView?.contentTextfield?.titleFont = UIFont.setCustomFont(name: .regular, size: .x12)
        self.customTextfieldView?.contentTextfield?.placeholderFont = UIFont.setCustomFont(name: .regular, size: .x18)
        self.customTextfieldView?.contentTextfield?.font = UIFont.setCustomFont(name: .regular, size: .x18)
        self.customTextfieldView?.contentTextfield?.titleColor = .midGreyColor
        self.customTextfieldView?.contentTextfield?.selectedTitleColor = .midGreyColor
        self.customTextfieldView?.setupField(selectType: .text, title: accountDetailsField.title, placeHolder: accountDetailsField.placeholder)
        self.customTextfieldView?.contentTextfield?.textColor = .primaryColor
        self.customTextfieldView?.contentTextfield?.tag = index
        self.customTextfieldView?.onClearOptions = {
//            print(index)
        }
    }
}

// MARK: TextField Delegates
extension AddBankCellTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.customTextfieldView?.contentTextfield?.keyboardType = .numberPad
        case 1:
            self.customTextfieldView?.contentTextfield?.keyboardType = .numberPad
        case 2:
            self.customTextfieldView?.contentTextfield?.autocapitalizationType = .allCharacters
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
                        if textField.text?.isValidIFSCCode() == true {
                            self.customTextfieldView?.hideErrorMessage()
                            self.isCustomTextFieldData?(textField.text ?? "", textField.tag)
                        } else {
                            self.customTextfieldView?.setErrorDescriptionView(errorDescription: ErrorAndDescription(type: .withError, description: "Enter Valid IFSC"))
                        }
        case 3:
            self.isCustomTextFieldData?(textField.text ?? "", textField.tag)
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty == true {
            return true
        }
        switch textField.tag {
        case 0:
            textField.isSecureTextEntry = true
            textField.text = textField.text?.formatFasTagCardNumber(isAccountNo: true)
            
        case 1:
            
            textField.text = textField.text?.formatFasTagCardNumber(isAccountNo: true)
            
        case 2:
            if textField.text?.count ?? 0 <= 10 {
                let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                let typedCharacterSet = CharacterSet(charactersIn: string)
                let isAllow = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                if !isAllow {
                    showSuccessToastMessage(message: "Only Upper case and Numbers are allowed", messageColor: .white, bgColour: UIColor.redErrorColor)
                }
                return isAllow
            } else {
                return false
            }
        case 3:
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            return allowedCharacterSet.isSuperset(of: typedCharacterSet )
        default:
            break
        }
        return true
    }
}
