//
//  ReasonsCellFor Closure.swift
//  FintechBase
//
//  Created by Sravani Madala on 28/07/23.
//

import UIKit

class ReasonsCellForClosure: UITableViewCell {
    
    @IBOutlet private weak var othersCustomView: UIView?
    @IBOutlet private weak var othersTextView: UITextView?
    @IBOutlet private weak var supportCustomView: UIView?
    @IBOutlet private weak var supportTitleLabel: UILabel?
    @IBOutlet private weak var supportDescLabel: UILabel?
    @IBOutlet private weak var goToSupportButton: UIButton?
    @IBOutlet private weak var reasonsTitleLabel: UILabel?
    @IBOutlet private weak var radioButtonImage: UIImageView?
    @IBOutlet private weak var textLimitLabel: UILabel?
    
    let charcterLimit = 250
    var isSupportButtonSelect: ((Bool) -> Void)?
    var otherReasonText: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialLoads()
    }
}

// MARK: Initial setup
extension ReasonsCellForClosure {
    
    // MARK: Initial Laods
    private func initialLoads() {
        self.supportCustomView?.isHidden = true
        self.othersCustomView?.isHidden = true
        self.othersTextView?.delegate = self
        self.setFont()
        self.setColor()
        self.backgroundColor = .clear
        self.setButton()
        self.setCustomViews()
    }
    
    // MARK: Set Views
    private func setCustomViews() {
        self.supportCustomView?.addLightShadow()
        self.supportCustomView?.setRoundedBorder(radius: 8, color: UIColor.lightDisableBackgroundColor.cgColor)
        self.othersCustomView?.addLightShadow()
        self.othersCustomView?.setRoundedBorder(radius: 8, color: UIColor.lightDisableBackgroundColor.cgColor)
        self.othersTextView?.autocorrectionType = .no
        self.othersTextView?.text = AppLoacalize.textString.additionalDetailsHere
        self.othersTextView?.textColor = .lightDisableBackgroundColor
        self.othersTextView?.font = .setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Set Button
    private func setButton() {
        self.goToSupportButton?.setup(title: AppLoacalize.textString.gotToSupport, type: .secondary, isEnabled: true, secondaryButtonSetup: SecondaryButtonSetup(borderColor: .primaryButtonColor, font: UIFont.setCustomFont(name: .regular, size: .x12)))
        self.goToSupportButton?.addTarget(self, action: #selector(supportButtonAction(_:)), for: .touchUpInside)
        self.radioButtonImage?.tintColor = .primaryButtonColor
    }
    
    // MARK: Set Data to Cell
    func setListData(resonsTitle: String?, selectedIndex: Bool) {
        if selectedIndex {
            self.radioButtonImage?.image = UIImage(named: Image.imageString.radioSelect)
        } else {
            self.radioButtonImage?.image = UIImage(named: Image.imageString.radioUnselect)
            self.showOthersCustomView(isSelect: false)
        }
        self.reasonsTitleLabel?.text = resonsTitle
    }
    
    // MARK: Hide and Show Supportview
    func showSupportCustomView(isSelect: Bool) {
        isSelect ? (self.supportCustomView?.isHidden = false) : (self.supportCustomView?.isHidden = true)
    }
    
    // MARK: Hide and Show OthersView
    func showOthersCustomView(isSelect: Bool) {
        if !isSelect {
            othersTextView?.textColor = .lightDisableBackgroundColor
            othersTextView?.text = AppLoacalize.textString.additionalDetailsHere
        }
        isSelect ? (self.othersCustomView?.isHidden = false) : (self.othersCustomView?.isHidden = true)
    }
    
    // MARK: Font
    private func setFont() {
        self.reasonsTitleLabel?.font = .setCustomFont(name: .regular, size: .x14)
        self.supportTitleLabel?.font = .setCustomFont(name: .semiBold, size: .x14)
        self.supportDescLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.textLimitLabel?.font = .setCustomFont(name: .regular, size: .x10)
    }
    
    // MARK: Color
    private func setColor() {
        self.reasonsTitleLabel?.textColor = .primaryColor
        self.supportTitleLabel?.textColor = .darkGreyDescriptionColor
        self.supportDescLabel?.textColor = .blusihGryColor
        self.textLimitLabel?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Button Actions
    @objc private func supportButtonAction(_ sender: UIButton) {
        self.isSupportButtonSelect?(true)
    }
}

// MARK: UITextView Delegates
extension ReasonsCellForClosure: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Check if limit is exceeded
        if textView == othersTextView {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: text)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)            
            if !alphabet {
                return false
            }
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= charcterLimit
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text.count
        self.textLimitLabel?.text = "\(textCount)/\(charcterLimit)"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightDisableBackgroundColor {
            textView.text = ""
            textView.textColor = .textBlackColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightDisableBackgroundColor
            textView.text = AppLoacalize.textString.additionalDetailsHere
            self.otherReasonText?("")
        } else {
            self.otherReasonText?(textView.text)
        }
    }
}
