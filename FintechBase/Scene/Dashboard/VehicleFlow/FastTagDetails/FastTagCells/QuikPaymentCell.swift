//
//  QuikPaymentCell.swift
//  FintechBase
//
//  Created by Sravani Madala on 11/08/23.
//

import UIKit

class QuikPaymentCell: UITableViewCell {

   @IBOutlet private weak var quikPaymentTitleLabel: UILabel?
   @IBOutlet private weak var quickImage: UIImageView?
   @IBOutlet private weak var qucikPaymentDescLabel: UILabel?
   @IBOutlet private weak var customView: UIView?
   @IBOutlet private weak var walletImage: UIImageView?
   @IBOutlet private weak var payViaQWalletLabel: UILabel?
   @IBOutlet private weak var walletBalanceLabel: UILabel?
   @IBOutlet private weak var rightArrowImage: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialLoads()
    }
}

//MARK : Intial Setup
extension QuikPaymentCell {
    func initialLoads() {
        self.setFont()
        self.setLoacalise()
        self.setColor()
        self.customView?.setCornerRadius(radius: 16)
    }
    
    // MARK: Font
    private func setFont() {
        self.quikPaymentTitleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.qucikPaymentDescLabel?.font = UIFont.setCustomFont(name: .regular, size: .x10)
        self.payViaQWalletLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x16)
        self.walletBalanceLabel?.font = UIFont.setCustomFont(name: .regular, size: .x10)
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.quikPaymentTitleLabel?.text = AppLoacalize.textString.quikPayment
        self.qucikPaymentDescLabel?.text = AppLoacalize.textString.quickPaymentDescription
        self.payViaQWalletLabel?.text = AppLoacalize.textString.payViaWallet
        self.walletBalanceLabel?.text = "\(AppLoacalize.textString.availableBalance): ₹ \(walletBalance)"
    }
    
    // MARK: Set Color
    private func setColor() {
        self.quikPaymentTitleLabel?.textColor = .midGreyColor
        self.qucikPaymentDescLabel?.textColor = .darkGreyDescriptionColor
        self.payViaQWalletLabel?.textColor = .primaryColor
        self.walletBalanceLabel?.textColor = .greenTextColor
    }
}
