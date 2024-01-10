//
//  OtherPaymentListTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 13/03/23.
//

import UIKit

class OtherPaymentListTableViewCell: UITableViewCell {

    @IBOutlet weak var dividerLineView: UIView?
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var transactionImageView: UIImageView?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var serviceChargeLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension OtherPaymentListTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setColor()
        self.setFont()
        
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .black
        self.dateLabel?.textColor = .midGreyColor
        self.serviceChargeLabel?.textColor = .brownishRedColor
        self.dividerLineView?.backgroundColor = .lightGreyTextColor
    }
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.dateLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.serviceChargeLabel?.font = UIFont.setCustomFont(name: .regular, size: .x10)
    }
}
