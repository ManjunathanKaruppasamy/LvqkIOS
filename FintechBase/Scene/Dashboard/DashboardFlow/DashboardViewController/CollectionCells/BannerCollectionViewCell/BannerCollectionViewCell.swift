//
//  BannerCollectionViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/03/23.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var viewContent: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

}

extension BannerCollectionViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setColor()
        self.setFont()
        self.setButton()
        self.viewContent?.layer.cornerRadius = 10
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryColor
        self.descriptionLabel?.textColor = .darkGreyDescriptionColor
    }
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.descriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Set Button
    private func setButton() {
//        let font = UIFont.setCustomFont(name: .regular, size: .x12)
//        self.addMoneyButton?.setup(title: AppLoacalize.textString.addMoney, type: .primary, isEnabled: true, primaryButtonSetup: PrimaryButtonSetup(bgColor: .secondaryColor, textColor: .white, font: font, cornerRadius: 5.0))
//        self.addMoneyButton?.addTarget(self, action: #selector(setAddMoneyAction(_:)), for: .touchUpInside)
        
    }
    // MARK: Set Add Money Button Action
    @objc private func setAddMoneyAction(_ sender: UIButton) {
    }
}
