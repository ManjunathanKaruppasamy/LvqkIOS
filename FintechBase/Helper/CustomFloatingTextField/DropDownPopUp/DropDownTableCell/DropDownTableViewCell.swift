//
//  DropDownTableViewCell.swift
//
//  Created by SENTHIL KUMAR on 11/07/22.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {

    @IBOutlet weak var dropDownListLabel: UILabel?
    @IBOutlet weak var dropDownSecondLabel: UILabel?
    @IBOutlet  weak var dropDownImage: UIImageView?
    @IBOutlet weak var imageWidthConstaraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropDownListLabel?.textColor = .primaryColor
        dropDownListLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        dropDownSecondLabel?.textColor = .primaryColor
        dropDownSecondLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
    }
    
    func setDropDownSetUp(isOnlyTitle: Bool) {
        if isOnlyTitle {
            self.dropDownImage?.isHidden = true
            self.dropDownSecondLabel?.isHidden = true
            self.imageWidthConstaraint?.constant = 0
        } else {
            self.imageWidthConstaraint?.constant = 32
            self.dropDownImage?.isHidden = false
            self.dropDownSecondLabel?.isHidden = false
            self.dropDownImage?.image = UIImage(named: Image.imageString.cardBlocked)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
