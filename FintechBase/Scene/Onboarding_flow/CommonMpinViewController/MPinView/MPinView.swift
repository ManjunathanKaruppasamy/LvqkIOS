//
//  MPinView.swift
//
//  Created by SENTHIL KUMAR on 13/07/22.
//

import Foundation
import UIKit

// swiftlint: disable class_delegate_protocol
// swiftlint: disable missing_docs
// swiftlint: disable function_body_length
// swiftlint: disable file_length
// swiftlint: disable identifier_name
public protocol M2PPinViewDelegate {
    func m2pPinViewAddText(_ text: String, at position: Int)
    func m2pPinViewRemoveText(_ text: String, at position: Int)
    func m2pPinViewChangePositionAt(_ position: Int)
    func m2pPinViewBecomeFirstResponder()
    func m2pPinViewResignFirstResponder()
}

@IBDesignable open class M2PPinView: UIView {
    
    /** The number of textField that will be put in the DPOTPView */
    @IBInspectable open dynamic var count: Int = 4
    
    /** Spaceing between textField in the DPOTPView */
    @IBInspectable open dynamic var spacing: CGFloat = 25
    
    /** Text color for the textField */
    @IBInspectable open dynamic var textColorTextField: UIColor = UIColor.black
    
    /** Text font for the textField */
    @IBInspectable open dynamic var fontTextField: UIFont = UIFont.systemFont(ofSize: 25)
    
    /** Placeholder */
    @IBInspectable open dynamic var placeholder: String = ""
    
    /** Placeholder text color for the textField */
    @IBInspectable open dynamic var placeholderTextColor: UIColor = UIColor.gray
    
    /** Circle textField */
    @IBInspectable open dynamic var isCircleTextField: Bool = false
    
    /** Allow only Bottom Line for the TextField */
    @IBInspectable open dynamic var isBottomLineTextField: Bool = false
    
    /** Background color for the textField */
    @IBInspectable open dynamic var backGroundColorTextField: UIColor = UIColor.clear
    
    /** Background color for the filled textField */
    @IBInspectable open dynamic var backGroundColorFilledTextField: UIColor?
    
    /** Border color for the TextField */
    @IBInspectable open dynamic var borderColorTextField: UIColor?
    
    /** Border color for the TextField */
    @IBInspectable open dynamic var selectedBorderColorTextField: UIColor?
    
    /** Border width for the TextField */
    @IBInspectable open dynamic var borderWidthTextField: CGFloat = 0.0
    
    /** Border width for the TextField */
    @IBInspectable open dynamic var selectedBorderWidthTextField: CGFloat = 0.0
    
    /** Corner radius for the TextField */
    @IBInspectable open dynamic var cornerRadiusTextField: CGFloat = 0.0
    
    /** Tint/cursor color for the TextField */
    @IBInspectable open dynamic var tintColorTextField: UIColor = UIColor.systemBlue
    
    /** Shadow Radius for the TextField */
    @IBInspectable open dynamic var shadowRadiusTextField: CGFloat = 0.0
    
    /** Shadow Opacity for the TextField */
    @IBInspectable open dynamic var shadowOpacityTextField: Float = 0.0
    
    /** Shadow Offset Size for the TextField */
    @IBInspectable open dynamic var shadowOffsetSizeTextField: CGSize = .zero
    
    /** Shadow color for the TextField */
    @IBInspectable open dynamic var shadowColorTextField: UIColor?
    
    /** Dismiss keyboard with enter last character*/
    @IBInspectable open dynamic var dismissOnLastEntry: Bool = false
    
    /** Secure Text Entry*/
    @IBInspectable open dynamic var isSecureTextEntry: Bool = false
    
    /** Hide cursor*/
    @IBInspectable open dynamic var isCursorHidden: Bool = false
    
    /** Dark keyboard*/
    @IBInspectable open dynamic var isDarkKeyboard: Bool = false
    
    open dynamic var textEdgeInsets: UIEdgeInsets?
    open dynamic var editingTextEdgeInsets: UIEdgeInsets?
    
    open dynamic var m2pPinViewDelegate: M2PPinViewDelegate?
    open dynamic var keyboardType: UIKeyboardType = UIKeyboardType.numberPad
    
    var type: MpinType?
    var mPinData: ((String, Int) -> Void)?
    var mpinEndData: ((String, Int) -> Void)?
    var moveNextField: (() -> Void)?
    var setBecomeFirstResponder: (() -> Void)?
    var isBackspaceClicked: (() -> Void)?
    open dynamic var text: String? {
        get {
            var str = ""
            arrTextFields.forEach { str.append($0.text ?? "") }
            return str
        } set {
            arrTextFields.forEach { $0.text = nil }
            for i in 0 ..< arrTextFields.count {
                
                 if i < (newValue?.count ?? 0) {
                    if let txt = newValue?[i..<i+1], let code = Int(txt) {
                        arrTextFields[i].text = String(code)
                    }
                 } else {
                     
                 }
            }
        }
    }
    
    fileprivate var arrTextFields: [OTPBackTextField] = []
    /** Override coder init, for IB/XIB compatibility */
    #if !TARGET_INTERFACE_BUILDER
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /** Override common init, for manual allocation */
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.initialization()
    }
    #endif
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initialization()
    }
    
    func PassInputData(text: String, index: Int) {
        self.mpinEndData?(text, index)
    }
    
    func setBorder() {
        arrTextFields.forEach {
            _ = $0.becomeFirstResponder()
        }
       _ = arrTextFields.first?.becomeFirstResponder()
    }
    
//    public func showError() {
//        // Set the default enteres state for otp entry
//        for index in stride(from: 0, to: count, by: 1) {
//            var otpField = viewWithTag(index + 1) as? OTPBackTextField
////            if otpField == nil {
////                otpField = getOTPField(forIndex: index, isCentre: fieldTobeCentre)
////            }
//            otpField?.layer.borderColor = UIColor.redErrorColor.cgColor
//            otpField?.textColor = .redErrorColor
//        }
//    }
    
    func initialization() {
        if !arrTextFields.isEmpty {
            return
        }
        let sizeTextField = (self.bounds.width/CGFloat(count)) - (spacing)
        for i in 1 ... count {
            let textField = OTPBackTextField()
            textField.keyboardToolbar.isHidden = false
            textField.delegate = self
            textField.OTPBackDelegate = self
            textField.dpOTPView = self
            textField.borderStyle = .none
            textField.tag = i * 1000
            textField.tintColor = tintColorTextField
            textField.backgroundColor = backGroundColorTextField
            textField.isSecureTextEntry = isSecureTextEntry
            textField.font = fontTextField
            textField.keyboardAppearance = isDarkKeyboard ? .dark : .default
            if isCursorHidden { textField.tintColor = .clear }
            if isBottomLineTextField {
                let border = CALayer()
                border.name = "bottomBorderLayer"
                textField.removePreviouslyAddedLayer(name: border.name ?? "")
                border.backgroundColor = borderColorTextField?.cgColor
                border.frame = CGRect(x: 0, y: sizeTextField - borderWidthTextField, width: sizeTextField, height: borderWidthTextField)
                textField.layer.addSublayer(border)
            } else {
                textField.layer.borderColor = borderColorTextField?.cgColor
                textField.layer.borderWidth = borderWidthTextField
                if isCircleTextField {
                    textField.layer.cornerRadius = sizeTextField / 2
                } else {
                    textField.layer.cornerRadius = cornerRadiusTextField
                }
            }
            textField.layer.shadowRadius = shadowRadiusTextField
            if let shadowColorTextField = shadowColorTextField {
                textField.layer.shadowColor = shadowColorTextField.cgColor
            }
            textField.layer.shadowOpacity = shadowOpacityTextField
            textField.layer.shadowOffset = shadowOffsetSizeTextField
            
            textField.textColor = textColorTextField
            textField.textAlignment = .center
            textField.keyboardType = keyboardType
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            }
            if placeholder.count > i - 1 {
                textField.attributedPlaceholder = NSAttributedString(string: placeholder[i - 1],
                                                                     attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor])
            }
            textField.frame = CGRect(x: (CGFloat(i-1) * sizeTextField) + (CGFloat(i) * spacing/2) + (CGFloat(i-1) * spacing/2),
                                     y: (self.bounds.height - sizeTextField)/2, width: sizeTextField, height: sizeTextField)
            arrTextFields.append(textField)
            self.addSubview(textField)
            if isCursorHidden {
                let tapView = UIView(frame: self.bounds)
                tapView.backgroundColor = .clear
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                tapView.addGestureRecognizer(tap)
                self.addSubview(tapView)
            }
        }
        self.setBecomeFirstResponder?()
//        if !arrTextFields.isEmpty {
//            _ = arrTextFields.first?.becomeFirstResponder()
//        }
    }
    
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//
//        super.draw(rect)
//    }
    
    open func setErrorBorder() {
        let sizeTextField = (self.bounds.width/CGFloat(count)) - (spacing)
        for i in 0 ..< arrTextFields.count {
            arrTextFields[i].textColor = UIColor.redErrorColor
            let border = CALayer()
            border.name = "bottomBorderLayer"
            arrTextFields[i].removePreviouslyAddedLayer(name: border.name ?? "")
            border.backgroundColor = UIColor.redErrorColor.cgColor
            border.frame = CGRect(x: 0, y: sizeTextField - borderWidthTextField, width: sizeTextField, height: borderWidthTextField)
            arrTextFields[i].layer.addSublayer(border)
        }
    }
    
    open func resetErrorBorder() {
        let sizeTextField = (self.bounds.width/CGFloat(count)) - (spacing)
        for i in 0 ..< arrTextFields.count {
            arrTextFields[i].textColor = textColorTextField
            let border = CALayer()
            border.name = "bottomBorderLayer"
            arrTextFields[i].removePreviouslyAddedLayer(name: border.name ?? "")
            border.backgroundColor = borderColorTextField?.cgColor
            border.frame = CGRect(x: 0, y: sizeTextField - borderWidthTextField, width: sizeTextField, height: borderWidthTextField)
            arrTextFields[i].layer.addSublayer(border)
        }
    }
    
    // swiftlint: disable identifier_name
    open override func becomeFirstResponder() -> Bool {
        if isCursorHidden {
            for i in 0 ..< arrTextFields.count {
                if arrTextFields[i].text?.isEmpty ?? true {
                    _ = arrTextFields[i].becomeFirstResponder()
                    break
                } else if (arrTextFields.count - 1) == i {
                    _ = arrTextFields[i].becomeFirstResponder()
                    break
                }
            }
        } else {
            _ = arrTextFields.first?.becomeFirstResponder()
        }
        m2pPinViewDelegate?.m2pPinViewBecomeFirstResponder()
        return super.becomeFirstResponder()
    }
    
    open override func resignFirstResponder() -> Bool {
        arrTextFields.forEach { (textField) in
            _ = textField.resignFirstResponder()
        }
        m2pPinViewDelegate?.m2pPinViewResignFirstResponder()
        return super.resignFirstResponder()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        _ = self.becomeFirstResponder()
    }
    
    func validate() -> Bool {
        var isValid = true
        arrTextFields.forEach { (textField) in
            if Int(textField.text ?? "") == nil {
                isValid = false
            }
        }
        return isValid
    }
}

extension M2PPinView: UITextFieldDelegate, OTPBackTextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        m2pPinViewDelegate?.m2pPinViewChangePositionAt(textField.tag/1000 - 1)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.mPinData?(((textField.text ?? "$").isEmpty ? "$": (textField.text ?? "$")), textField.tag)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            textField.text = string
            if textField.tag < count*1000 {
                let next = textField.superview?.viewWithTag((textField.tag/1000 + 1)*1000)
                next?.becomeFirstResponder()
            } else if textField.tag == count*1000 && (dismissOnLastEntry || type == .changeMpin) {
                self.PassInputData(text: ((textField.text ?? "$").isEmpty ? "$":(textField.text ?? "$")), index: textField.tag)
//                textField.resignFirstResponder()
            } else {
                moveNextField?()
            }
        } else if string.isEmpty { // is backspace
            textField.text = ""
            self.isBackspaceClicked?()
        }
        m2pPinViewDelegate?.m2pPinViewAddText(text ?? "", at: textField.tag/1000 - 1)
        return false
    }
    
    func textFieldDidDelete(_ textField: UITextField) {
        if textField.tag > 1000, let next = textField.superview?.viewWithTag((textField.tag/1000 - 1)*1000) as? UITextField {
            next.text = ""
            next.becomeFirstResponder()
            self.isBackspaceClicked?()
            m2pPinViewDelegate?.m2pPinViewRemoveText(text ?? "", at: next.tag/1000 - 1)
        }
    }
}

protocol OTPBackTextFieldDelegate {
    func textFieldDidDelete(_ textField: UITextField)
}

 class OTPBackTextField: UITextField {
    
    var OTPBackDelegate: OTPBackTextFieldDelegate?
    weak var dpOTPView: M2PPinView!
    override var text: String? {
        didSet {
            if text?.isEmpty ?? true {
                self.backgroundColor = dpOTPView.backGroundColorTextField
            } else {
                self.backgroundColor = dpOTPView.backGroundColorFilledTextField ?? dpOTPView.backGroundColorTextField
            }
        }
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        OTPBackDelegate?.textFieldDidDelete(self)
    }
    
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
////        if action == #selector(UIResponderStandardEditActions.copy(_:)) ||
////            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
////            action == #selector(UIResponderStandardEditActions.select(_:)) ||
////            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
////            action == #selector(UIResponderStandardEditActions.delete(_:)) {
////
////            return false
////        }
////        return super.canPerformAction(action, withSender: sender)
//        return false
//    }
    
    override func becomeFirstResponder() -> Bool {
//        addSelectedBorderColor()
        addUnselectedBorderColor()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        addUnselectedBorderColor()
        return super.resignFirstResponder()
    }
    
//    fileprivate func addSelectedBorderColor() {
//        if let selectedBorderColor = dpOTPView.selectedBorderColorTextField {
//            if dpOTPView.isBottomLineTextField {
//                addBottomLine(selectedBorderColor, width: dpOTPView.selectedBorderWidthTextField)
//            } else {
//                layer.borderColor = selectedBorderColor.cgColor
//                layer.borderWidth = dpOTPView.selectedBorderWidthTextField
//            }
//        } else {
//            if dpOTPView.isBottomLineTextField {
//                removePreviouslyAddedLayer(name: "bottomBorderLayer")
//            } else {
//                layer.borderColor = nil
//                layer.borderWidth = 0
//            }
//        }
//    }
    
    fileprivate func addUnselectedBorderColor() {
        if let unselectedBorderColor = dpOTPView.borderColorTextField {
            if dpOTPView.isBottomLineTextField {
                addBottomLine(unselectedBorderColor, width: dpOTPView.borderWidthTextField)
            } else {
                layer.borderColor = unselectedBorderColor.cgColor
                layer.borderWidth = dpOTPView.borderWidthTextField
            }
        } else {
            if dpOTPView.isBottomLineTextField {
                removePreviouslyAddedLayer(name: "bottomBorderLayer")
            } else {
                layer.borderColor = nil
                layer.borderWidth = 0
            }
        }
    }
    
    fileprivate func addBottomLine(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "bottomBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = (self.text ?? "").isEmpty ? UIColor.blusihGryColor.cgColor : UIColor.blusihGryColor.cgColor// color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.width - width, width: self.frame.width, height: width)
        self.layer.addSublayer(border)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
         bounds.inset(by: dpOTPView.textEdgeInsets ?? UIEdgeInsets.zero)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         bounds.inset(by: dpOTPView.editingTextEdgeInsets ?? UIEdgeInsets.zero)
    }
    
    fileprivate func removePreviouslyAddedLayer(name: String) {
        if self.layer.sublayers?.count ?? 0 > 0 {
            self.layer.sublayers?.forEach {
                if $0.name == name {
                    $0.removeFromSuperlayer()
                }
            }
        }
    }
}

// swiftlint: disable identifier_name
fileprivate extension String {
//    subscript(_ i: Int) -> String {
//        let idx1 = index(startIndex, offsetBy: i)
//        let idx2 = index(idx1, offsetBy: 1)
//        return String(self[idx1..<idx2])
//    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
    }
    
    subscript (r: CountableClosedRange<Int>) -> String {
        let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[startIndex...endIndex])
    }
}

class CustomSecureTextField: UITextField {
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()

        if !isSecureTextEntry {
            return true
            
        }

        if let currentText = text { insertText(currentText) }

        return true
    }
}
