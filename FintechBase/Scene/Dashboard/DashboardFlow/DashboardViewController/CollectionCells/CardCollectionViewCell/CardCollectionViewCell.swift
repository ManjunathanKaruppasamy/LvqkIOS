//
//  CardCollectionViewCell.swift
//  FintechBase
//
//  Created by Balaji  on 03/03/23.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView?
    @IBOutlet weak var bgImageView: UIImageView?
    @IBOutlet weak var fastagImageView: UIImageView?
    @IBOutlet weak var userNameLabel: UILabel?
    @IBOutlet weak var amountLabel: UILabel?
    @IBOutlet weak var cardNoLabel: UILabel?
    @IBOutlet weak var addMoneyButton: UIButton?
    @IBOutlet weak var manageCardButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    // MARK: Set Data
    func setData(data: String) {
        
    }
}

extension CardCollectionViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setColor()
        self.setFont()
        self.setButton()
    }
    
    // MARK: Color
    private func setColor() {
        self.userNameLabel?.textColor = .lightGreyTextColor
        self.amountLabel?.textColor = .white
        self.cardNoLabel?.textColor = .white
        
    }
    // MARK: Font
    private func setFont() {
        self.userNameLabel?.font = UIFont.setCustomFont(name: .regular, size: .x10)
        self.amountLabel?.font = UIFont.setCustomFont(name: .regular, size: .x24)
        self.cardNoLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        
    }
    
    // MARK: Set Button
    private func setButton() {
        let font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.addMoneyButton?.setup(title: AppLoacalize.textString.addMoney, type: .primary, isEnabled: true, primaryButtonSetup: PrimaryButtonSetup(bgColor: .secondaryColor, textColor: .white, font: font, cornerRadius: 5.0))
        
        self.manageCardButton?.setup(title: AppLoacalize.textString.manageCard, type: .secondary, isEnabled: true, secondaryButtonSetup: SecondaryButtonSetup(borderColor: .lightGreyTextColor, textColor: .lightGreyTextColor, font: font, cornerRadius: 5.0))
        
    }
}
