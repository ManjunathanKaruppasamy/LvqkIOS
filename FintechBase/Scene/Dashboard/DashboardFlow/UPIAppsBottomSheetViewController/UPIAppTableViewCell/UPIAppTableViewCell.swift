//
//  UPIAppTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/06/23.
//

import UIKit

class UPIAppTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var upiImageView: UIImageView?
    @IBOutlet weak var upiNameLabel: UILabel?
    @IBOutlet weak var divideLinezview: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
