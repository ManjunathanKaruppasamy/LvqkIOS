//
//  M2PHeaderViewTableViewCell.swift
//  FinTechProductBase
//
//  Created by Balaji  on 22/09/20.
//  Copyright © 2020 sidhudevarayan. All rights reserved.
//

import UIKit

class M2PHeaderViewTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var mainView: UIView?
    @IBOutlet weak var headerLbl: UILabel?
    
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
        headerLbl?.font = .setCustomFont(name: .semiBold, size: .x14)
        // style
        headerLbl?.textColor = .darkGreyDescriptionColor
    }
    
}
