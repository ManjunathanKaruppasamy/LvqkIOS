//
//  NoVehicleCollectionViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 07/08/23.
//

import UIKit

class NoVehicleCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var noVehicleImageView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var viewContent: UIView?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
}

extension NoVehicleCollectionViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setColor()
        self.setFont()
        self.setDescriptionField()
        self.viewContent?.layer.cornerRadius = 12
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .white
        self.descriptionLabel?.textColor = .white
    }
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x16)
        self.descriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Set Button
    private func setDescriptionField() {
        self.titleLabel?.text = AppLoacalize.textString.novehicleTitle
        let descriptionLabelAttributedString = NSMutableAttributedString(string: AppLoacalize.textString.novehicleDescription)
        descriptionLabelAttributedString.applyUnderLineText(color: .white, subString: "Get it now", textFont: UIFont.setCustomFont(name: .regular, size: .x12), textColor: .white)
        self.descriptionLabel?.attributedText = descriptionLabelAttributedString
        self.descriptionLabel?.isUserInteractionEnabled = true
    }
}
