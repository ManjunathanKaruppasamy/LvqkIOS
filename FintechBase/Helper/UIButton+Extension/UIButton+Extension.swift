//
//  UIButton+Extension.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/02/23.
//

import Foundation
import UIKit

enum CustomButtonType {
    case primary
    case secondary
    case skip
}

struct PrimaryButtonSetup {
    var bgColor: UIColor = .primaryButtonColor
    var textColor: UIColor = .white
    var disableBgColor: UIColor = .lightDisableBackgroundColor
    var disableTextColor: UIColor = .midGreyColor
    var font: UIFont = UIFont.setCustomFont(name: .regular, size: .x16)
    var cornerRadius: CGFloat = 10.0
}

struct SecondaryButtonSetup {
    var borderColor: UIColor = .primaryButtonColor
    var textColor: UIColor = .primaryButtonColor
    var disableBorderColor: UIColor = .midGreyColor
    var disableTextColor: UIColor = .midGreyColor
    var font: UIFont = UIFont.setCustomFont(name: .regular, size: .x16)
    var cornerRadius: CGFloat = 10.0
}

extension UIButton {
    
    func setup(title: String? = nil, type: CustomButtonType, isEnabled: Bool = true, primaryButtonSetup: PrimaryButtonSetup = PrimaryButtonSetup(), secondaryButtonSetup: SecondaryButtonSetup = SecondaryButtonSetup(), skipButtonFont: UIFont = UIFont.setCustomFont(name: .regular, size: .x12)) {
        setTitle(title, for: .normal)
        if type == .primary {
            setPrimaryButtonState(isEnabled: isEnabled, primaryButtonSetup: primaryButtonSetup)
        } else if type == .secondary {
            setSecondaryButtonState(isEnabled: isEnabled, secondaryButtonSetup: secondaryButtonSetup)
        } else if type == .skip {
            setSkipButtonState(isEnabled: isEnabled, font: skipButtonFont)
        }
        
    }
    
    func setPrimaryButtonState(isEnabled: Bool, primaryButtonSetup: PrimaryButtonSetup = PrimaryButtonSetup()) {
        setCornerRadius(radius: primaryButtonSetup.cornerRadius)
        self.isEnabled = isEnabled
        titleLabel?.font = primaryButtonSetup.font
        if isEnabled {
            backgroundColor = primaryButtonSetup.bgColor
            setTitleColor(primaryButtonSetup.textColor, for: .normal)
        } else {
            backgroundColor = primaryButtonSetup.disableBgColor
            setTitleColor(primaryButtonSetup.disableTextColor, for: .disabled)
        }
    }
    
    func setSecondaryButtonState(isEnabled: Bool, secondaryButtonSetup: SecondaryButtonSetup = SecondaryButtonSetup()) {
        setCornerRadius(radius: secondaryButtonSetup.cornerRadius)
        self.isEnabled = isEnabled
        backgroundColor = .clear
        titleLabel?.font = secondaryButtonSetup.font
        if isEnabled {
            setTitleColor(secondaryButtonSetup.textColor, for: .normal)
            setRoundedBorder(radius: secondaryButtonSetup.cornerRadius, color: secondaryButtonSetup.borderColor.cgColor, width: 1.5)
        } else {
            setTitleColor(secondaryButtonSetup.disableTextColor, for: .disabled)
            setRoundedBorder(radius: secondaryButtonSetup.cornerRadius, color: secondaryButtonSetup.disableBorderColor.cgColor, width: 1.5)
        }
    }
    
    func setSkipButtonState(isEnabled: Bool, font: UIFont = UIFont.setCustomFont(name: .regular, size: .x12)) {
        self.isEnabled = isEnabled
        titleLabel?.font = font
        if isEnabled {
            backgroundColor = .clear
            setTitleColor(.hyperLinkColor, for: .normal)
        } else {
            backgroundColor = .clear
            setTitleColor(.midGreyColor, for: .disabled)
        }
    }
    
}
