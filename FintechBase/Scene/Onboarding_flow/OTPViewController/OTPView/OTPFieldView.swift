//
//  OTPFieldView.swift
//  M2PSDK
//
//  Created by SENTHIL KUMAR on 07/11/22.
//

import UIKit

protocol OTPFieldViewDelegate: AnyObject {
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool
    func enteredOTP(otp: String, otpView: OTPFieldView)
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool
}

@objc enum DisplayType: Int {
    case circular
    case roundedCorner
    case square
    case diamond
    case underlinedBottom
}

/// Different input type for OTP fields.
@objc enum KeyboardType: Int {
    case numeric
    case alphabet
    case alphaNumeric
}

@objc class OTPFieldView: UIView {
    /// Different display type for text fields.
    public var displayType: DisplayType = .circular
    public var fieldsCount: Int = 4
    public var otpInputType: KeyboardType = .numeric
    public var fieldFont: UIFont = UIFont.systemFont(ofSize: 20)
    public var secureEntry: Bool = false
    public var hideEnteredText: Bool = false
    public var requireCursor: Bool = true
    public var cursorColor: UIColor = UIColor.blue
    public var fieldSize: CGFloat = 60
    public var separatorSpace: CGFloat = 16
    public var fieldBorderWidth: CGFloat = 1
    public var shouldAllowIntermediateEditing: Bool = true
    public var defaultBackgroundColor: UIColor = UIColor.clear
    public var filledBackgroundColor: UIColor = UIColor.clear
    public var defaultBorderColor: UIColor = UIColor.gray
    public var filledBorderColor: UIColor = UIColor.clear
    public var errorBorderColor: UIColor? = UIColor.clear
    public var errorColor: UIColor? = UIColor.clear
    public var otpTextColor: UIColor = UIColor.white
    public var fromView: OTPFieldView?
    public var callLayoutSubviews: Bool = true
    public var fieldTobeCentre: Bool = true
    public weak var delegate: OTPFieldViewDelegate?
    public var OTPString: String?
    fileprivate var secureEntryData = [String]()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func layoutSubviews() {
        //        initializeOTPFields()
        if callLayoutSubviews {
            initializeOTPFieldsWithValue(values: OTPString ?? "")
        }
    }
    
    public func initializeUI(setResponder: Bool? = false) {
        layer.masksToBounds = true
        layoutIfNeeded()
        initializeOTPFields()
        layoutIfNeeded()
        if setResponder == true {
            (viewWithTag(1) as? OTPTextField)?.becomeFirstResponder()
        } else {
            
        }
        //         Forcefully try to make first otp field as first responder
        //        (viewWithTag(1) as? OTPTextField)?.becomeFirstResponder()
    }
    
    public func initializeUIWithSetValues(values: String) {
        layer.masksToBounds = true
        layoutIfNeeded()
        self.OTPString = values
        initializeOTPFieldsWithValue(values: values)
        layoutIfNeeded()
    }
    
    public func initializeOTPFields() {
        secureEntryData.removeAll()
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            let oldOtpField = viewWithTag(index + 1) as? OTPTextField
            oldOtpField?.removeFromSuperview()
            let otpField = getOTPField(forIndex: index, isCentre: fieldTobeCentre)
            addSubview(otpField)
            secureEntryData.append("")
        }
    }
    
    public func initializeOTPFieldsWithValue(values: String?) {
        secureEntryData.removeAll()
        guard let string = values, !string.isEmpty else {
            return
        }
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            let oldOtpField = viewWithTag(index + 1) as? OTPTextField
            oldOtpField?.removeFromSuperview()
            let otpField = getOTPField(forIndex: index, isCentre: fieldTobeCentre)
            otpField.setText(value: "\(Array(string)[index])")

            otpField.isUserInteractionEnabled = false
            addSubview(otpField)
            
            secureEntryData.append("")
        }
    }
    
    /* Show Error */
    public func showError() {
        // Set the default enteres state for otp entry
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            var otpField = viewWithTag(index + 1) as? OTPTextField
            if otpField == nil {
                otpField = getOTPField(forIndex: index, isCentre: fieldTobeCentre)
            }
            otpField?.otpBorderColor = .redErrorColor
            otpField?.textColor = .redErrorColor
            otpField?.initalizeUI(forFieldType: .underlinedBottom)
        }
    }
    
    /* Hide Error */
    public func hideError() {
        // Set the default enteres state for otp entry
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            var otpField = viewWithTag(index + 1) as? OTPTextField
            if otpField == nil {
                otpField = getOTPField(forIndex: index, isCentre: fieldTobeCentre)
            }
            otpField?.otpBorderColor = defaultBorderColor
            otpField?.textColor = otpTextColor
            otpField?.initalizeUI(forFieldType: .underlinedBottom)
        }
    }
    
    /* Clear All Field */
    public func clearAllField() {
        // Set the default enteres state for otp entry
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            var otpField = viewWithTag(index + 1) as? OTPTextField
            if otpField == nil {
                otpField = getOTPField(forIndex: index, isCentre: fieldTobeCentre)
            }
            otpField?.setText(value: "")
        }
    }
    
    fileprivate func getOTPField(forIndex index: Int, isCentre: Bool) -> OTPTextField {
        let hasOddNumberOfFields = (fieldsCount % 2 == 1)
        var fieldFrame = CGRect(x: 0, y: 0, width: fieldSize, height: fieldSize + 10.0)
        
        if hasOddNumberOfFields {
            if isCentre {
                // Calculate from middle each fields x and y values so as to align the entire view in center
                fieldFrame.origin.x = bounds.size.width / 2 - (CGFloat(fieldsCount / 2 - index) * (fieldSize + separatorSpace) + fieldSize / 2)
            } else {
                // Calculate from origin each fields x and y values so as to align the entire view from left
                fieldFrame.origin.x = CGFloat(index) * (CGFloat(fieldsCount / 2 - index) + fieldSize + separatorSpace + separatorSpace / 2)
            }
        } else {
            if isCentre {
                // Calculate from middle each fields x and y values so as to align the entire view in center
                fieldFrame.origin.x = bounds.size.width / 2 - (CGFloat(fieldsCount / 2 - index) * fieldSize + CGFloat(fieldsCount / 2 - index - 1) * separatorSpace + separatorSpace / 2)
            } else {
                // Calculate from origin each fields x and y values so as to align the entire view from left
                fieldFrame.origin.x = CGFloat(index) * (CGFloat(fieldsCount / 2 - index) + fieldSize + separatorSpace + separatorSpace / 2)
            }
        }
        
        fieldFrame.origin.y = (bounds.size.height - fieldSize) / 2
        
        let otpField = OTPTextField(frame: fieldFrame)
        otpField.delegate = self
        otpField.tag = index + 1
        otpField.font = fieldFont
        
        // Set input type for OTP fields
        switch otpInputType {
        case .numeric:
            otpField.keyboardType = .numberPad
        case .alphabet:
            otpField.keyboardType = .alphabet
        case .alphaNumeric:
            otpField.keyboardType = .namePhonePad
        }
        
        // Set the border values if needed
        otpField.otpBorderColor = defaultBorderColor
        otpField.otpBorderWidth = fieldBorderWidth
        
        if requireCursor {
            otpField.tintColor = cursorColor
        } else {
            otpField.tintColor = UIColor.clear
        }
        
        // Set the default background color when text not set
        otpField.backgroundColor = defaultBackgroundColor
        
        // Finally create the fields
        otpField.initalizeUI(forFieldType: displayType)
        otpField.textColor = otpTextColor
        return otpField
    }
    
    fileprivate func isPreviousFieldsEntered(forTextField textField: UITextField) -> Bool {
        var isTextFilled = true
        var nextOTPField: UITextField?
        
        // If intermediate editing is not allowed, then check for last filled field in forward direction.
        if !shouldAllowIntermediateEditing {
            for index in stride(from: 1, to: fieldsCount + 1, by: 1) {
                let tempNextOTPField = viewWithTag(index) as? UITextField
                
                if let tempNextOTPFieldText = tempNextOTPField?.text, tempNextOTPFieldText.isEmpty {
                    nextOTPField = tempNextOTPField
                    
                    break
                }
            }
            
            if let nextOTPField = nextOTPField {
                isTextFilled = (nextOTPField == textField || (textField.tag) == (nextOTPField.tag - 1))
            }
        }
        
        return isTextFilled
    }
    
    // swiftlint: disable cyclomatic_complexity
    // Helper function to get the OTP String entered
    fileprivate func calculateEnteredOTPSTring(isDeleted: Bool) {
        
        if isDeleted {
            _ = delegate?.hasEnteredAllOTP(hasEnteredAll: false)
            
            // Set the default enteres state for otp entry
            for index in stride(from: 0, to: fieldsCount, by: 1) {
                var otpField = viewWithTag(index + 1) as? OTPTextField
                
                if otpField == nil {
                    otpField = getOTPField(forIndex: index, isCentre: fieldTobeCentre)
                } else {
                }
                let fieldBackgroundColor = (otpField?.text ?? "").isEmpty ? defaultBackgroundColor : filledBackgroundColor
                let fieldBorderColor = (otpField?.text ?? "").isEmpty ? defaultBorderColor : filledBorderColor
                
                if displayType == .diamond || displayType == .underlinedBottom {
                    otpField?.shapeLayer.fillColor = fieldBackgroundColor.cgColor
                    otpField?.shapeLayer.strokeColor = fieldBorderColor.cgColor
                } else {
                    otpField?.backgroundColor = fieldBackgroundColor
                    otpField?.layer.borderColor = fieldBorderColor.cgColor
                }
            }
        } else {
            
            var enteredOTPString = ""
            
            // Check for entered OTP
            for index in stride(from: 0, to: secureEntryData.count, by: 1) {
                if !secureEntryData[index].isEmpty {
                    enteredOTPString.append(secureEntryData[index])
                } else {
                }
            }
            
            if enteredOTPString.count == fieldsCount {
                delegate?.enteredOTP(otp: enteredOTPString, otpView: fromView ?? OTPFieldView())
                
                // Check if all OTP fields have been filled or not. Based on that call the 2 delegate methods.
                let isValid = delegate?.hasEnteredAllOTP(hasEnteredAll: (enteredOTPString.count == fieldsCount)) ?? false
                
                // Set the error state for invalid otp entry
                for index in stride(from: 0, to: fieldsCount, by: 1) {
                    var otpField = viewWithTag(index + 1) as? OTPTextField
                    
                    if otpField == nil {
                        otpField = getOTPField(forIndex: index, isCentre: fieldTobeCentre)
                    } else {
                    }
                    
                    if !isValid {
                        // Set error border color if set, if not, set default border color
                        otpField?.layer.borderColor = (errorBorderColor ?? filledBorderColor).cgColor
                    } else {
                        otpField?.layer.borderColor = filledBorderColor.cgColor
                    }
                }
            } else {
            }
        }
        
        var enteredOTPString = ""
        // Check for entered OTP
        for index in stride(from: 0, to: secureEntryData.count, by: 1) {
            if !secureEntryData[index].isEmpty {
                enteredOTPString.append(secureEntryData[index])
            } else {
            }
        }
        delegate?.enteredOTP(otp: enteredOTPString, otpView: fromView ?? OTPFieldView())
    }
    
}

extension OTPFieldView: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let shouldBeginEditing = delegate?.shouldBecomeFirstResponderForOTP(otpTextFieldIndex: (textField.tag - 1)) ?? true
        if shouldBeginEditing {
            return isPreviousFieldsEntered(forTextField: textField)
        }
        return shouldBeginEditing
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let replacedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Check since only alphabet keyboard is not available in iOS
        if !replacedText.isEmpty && otpInputType == .alphabet && replacedText.rangeOfCharacter(from: .letters) == nil {
            return false
        }
        
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        /*if ((textField.text?.count)! + (string.count - range.length)) > 1 {
         return false
         }*/
        
        if replacedText.count >= 1 {
            // If field has a text already, then replace the text and move to next field if present
            secureEntryData[textField.tag - 1] = string
            
            if hideEnteredText {
                textField.text = " "
            } else {
                textField.text = secureEntry ? "\u{FF0A}" : string
            }
            
            if displayType == .diamond || displayType == .underlinedBottom {
                (textField as? OTPTextField)?.shapeLayer.fillColor = filledBackgroundColor.cgColor
                (textField as? OTPTextField)?.shapeLayer.strokeColor = filledBorderColor.cgColor
            } else {
                textField.backgroundColor = filledBackgroundColor
                textField.layer.borderColor = filledBorderColor.cgColor
            }
            
            let nextOTPField = viewWithTag(textField.tag + 1)
            
            if let nextOTPField = nextOTPField {
                nextOTPField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            
            // Get the entered string
            calculateEnteredOTPSTring(isDeleted: false)
        } else {
            let currentText = textField.text ?? ""
            
            if textField.tag > 1 && currentText.isEmpty {
                if let prevOTPField = viewWithTag(textField.tag - 1) as? UITextField {
                    deleteText(in: prevOTPField)
                } else {
                }
            } else {
                deleteText(in: textField)
                
                if textField.tag > 1 {
                    if let prevOTPField = viewWithTag(textField.tag - 1) as? UITextField {
                        prevOTPField.becomeFirstResponder()
                    } else {
                    }
                }
            }
        }
        return false
    }
    
    private func deleteText(in textField: UITextField) {
        // If deleting the text, then move to previous text field if present
        secureEntryData[textField.tag - 1] = ""
        textField.text = ""
        
        if displayType == .diamond || displayType == .underlinedBottom {
            (textField as? OTPTextField)?.shapeLayer.fillColor = defaultBackgroundColor.cgColor
            (textField as? OTPTextField)?.shapeLayer.strokeColor = defaultBorderColor.cgColor
        } else {
            textField.backgroundColor = defaultBackgroundColor
            textField.layer.borderColor = defaultBorderColor.cgColor
        }
        
        textField.becomeFirstResponder()
        
        // Get the entered string
        calculateEnteredOTPSTring(isDeleted: true)
    }
}
extension String {
    subscript(_ onIndex: Int) -> String {
        if !self.isEmpty && self.count > onIndex {
            let idx1 = index(startIndex, offsetBy: onIndex)
            let idx2 = index(idx1, offsetBy: 1)
            return String(self[idx1..<idx2])
        } else {
            return ""
        }
    }
}
