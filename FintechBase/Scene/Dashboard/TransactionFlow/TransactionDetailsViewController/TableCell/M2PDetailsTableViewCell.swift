//
//  M2PDetailsTableViewCell.swift
//  PCIWidget
//
//  Created by Balaji  on 14/03/23.
//  Copyright © 2023 Ranjith Ravichandran. All rights reserved.
//

import UIKit

class M2PDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLbl: UILabel?
    @IBOutlet private weak var valueLbl: UILabel?
    @IBOutlet weak var cellBottomAnchorConstraint: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setStyles()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /* Set Style */
    private func setStyles() {
        // font
        nameLbl?.font = .setCustomFont(name: .regular, size: .x14)
        valueLbl?.font = .setCustomFont(name: .medium, size: .x14)
        // style
        nameLbl?.textColor = .darkGreyDescriptionColor
        valueLbl?.textColor = .primaryColor
    }
    
    func setDetails(model: TransactionDetailModel) {
        self.nameLbl?.text = model.name
        self.valueLbl?.text = model.value
    }
    
}
