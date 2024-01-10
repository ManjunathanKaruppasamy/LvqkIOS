//
//  VehicleMessageTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 14/03/23.
//

import UIKit

class VehicleMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var warningImage: UIImageView?
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var bgView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: Initial Setup
extension VehicleMessageTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setColor()
        self.setFont()
        self.viewContent?.layer.cornerRadius = 10
        self.bgView?.layer.cornerRadius = 10
        
    }
    
    // MARK: Color
    private func setColor() {
        self.messageLabel?.textColor = .blusihGryColor
        self.viewContent?.backgroundColor = .orange.withAlphaComponent(0.1)
    }
    // MARK: Font
    private func setFont() {
        self.messageLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.messageLabel?.text = AppLoacalize.textString.vehicleScreenBottomMessageText
    }
    
}
