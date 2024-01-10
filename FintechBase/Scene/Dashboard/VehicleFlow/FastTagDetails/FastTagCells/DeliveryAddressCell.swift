//
//  DeliveryAddressCell.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//

import UIKit

class DeliveryAddressCell: UITableViewCell {

    @IBOutlet private weak var customView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var changeButton: UIButton?
    @IBOutlet private weak var addressValueLabel: UILabel?
   
    var onClickChange: ((Bool) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialLoad()
    }
    private func initialLoad() {
        self.setFont()
        self.setLoacalise()
        self.setColor()
        setButton()
        self.customView?.backgroundColor = .white
        self.customView?.addLightShadow(radius: 16)
    }

    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.addressValueLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.titleLabel?.text = AppLoacalize.textString.deliveryAddress
    }
    
    // MARK: Set Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryButtonColor
        self.addressValueLabel?.textColor = .primaryColor
    }
    // MARK: Set Button
    private func setButton() {
        self.changeButton?.setup(title: AppLoacalize.textString.change, type: CustomButtonType.secondary, isEnabled: true, secondaryButtonSetup: SecondaryButtonSetup(borderColor: .clear, textColor: .hyperLinkColor))
        self.changeButton?.addTarget(self, action: #selector(changeButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc private func changeButtonAction(_ sender: UIButton) {
        self.onClickChange?(true)
    }
}
