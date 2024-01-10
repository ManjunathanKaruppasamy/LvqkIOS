//
//  FastTagFeeBreakdownCell.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//

import UIKit

class FastTagFeeBreakdownCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var fastTagImage: UIImageView?
    @IBOutlet private weak var stackView: UIStackView?
    @IBOutlet private weak var tagIssuanceFeeStaticLabel: UILabel?
    @IBOutlet private weak var tagIssuanceFeeValueLabel: UILabel?
    @IBOutlet private weak var gstStaticLabel: UILabel?
    @IBOutlet private weak var gstValueLabel: UILabel?
    @IBOutlet private weak var fastTagBalanceStaticLabel: UILabel?
    @IBOutlet private weak var fastTagBalanceValueLabel: UILabel?
    @IBOutlet private weak var totalStaticLabel: UILabel?
    @IBOutlet private weak var totalValueLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func initialLoad() {
        self.setFont()
        self.setLoacalise()
        self.setColor()
    }

    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.tagIssuanceFeeStaticLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.tagIssuanceFeeValueLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.gstStaticLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.gstValueLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.fastTagBalanceStaticLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.fastTagBalanceValueLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        self.totalStaticLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.totalValueLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.titleLabel?.text = AppLoacalize.textString.qWFASTagFeedetails
        self.tagIssuanceFeeStaticLabel?.text = AppLoacalize.textString.tagIssuanceFee
        self.gstStaticLabel?.text = AppLoacalize.textString.gstPercentage
        self.fastTagBalanceStaticLabel?.text = AppLoacalize.textString.fastTagBalance
        self.totalStaticLabel?.text = AppLoacalize.textString.total
    }
    
    // MARK: Set Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryButtonColor
        self.tagIssuanceFeeStaticLabel?.textColor = .darkGreyDescriptionColor
        self.gstStaticLabel?.textColor = .darkGreyDescriptionColor
        self.fastTagBalanceStaticLabel?.textColor = .darkGreyDescriptionColor
        self.totalStaticLabel?.textColor = .darkGreyDescriptionColor
        self.tagIssuanceFeeValueLabel?.textColor = .primaryColor
        self.gstValueLabel?.textColor = .primaryColor
        self.fastTagBalanceValueLabel?.textColor = .primaryColor
        self.totalValueLabel?.textColor = .primaryColor
    }
    
    func setCellData(fastTagFeeData: FastTagFeeResult?) {
        self.tagIssuanceFeeValueLabel?.text = "\(rupeeSymbol)" + "\(fastTagFeeData?.tagFee ?? 0.0)".getRequiredFractionFormat()
        self.gstValueLabel?.text = "\(rupeeSymbol)" + "\(rupeeSymbol) \(fastTagFeeData?.gst ?? 0.0)".getRequiredFractionFormat()
        self.fastTagBalanceValueLabel?.text = "\(rupeeSymbol)" + "\(fastTagFeeData?.fastTagBalance ?? 0.0)".getRequiredFractionFormat()
        self.totalValueLabel?.text = "\(rupeeSymbol)" + "\(fastTagFeeData?.total ?? 0.0)".getRequiredFractionFormat()
    }
}
