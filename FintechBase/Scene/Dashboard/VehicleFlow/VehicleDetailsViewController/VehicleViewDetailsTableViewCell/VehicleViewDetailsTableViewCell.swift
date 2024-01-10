//
//  VehicleViewDetailsTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 15/03/23.
//

import UIKit

class VehicleViewDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
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
extension VehicleViewDetailsTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setColor()
        self.setFont()
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .midGreyColor
        self.descriptionLabel?.textColor = .primaryColor
        
    }
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.descriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x16)
    }
    
}

// MARK: Set Data
extension VehicleViewDetailsTableViewCell {
    
    func setupView(vehicleDetailsData: VehicleDetailsData) {
        self.titleLabel?.text = vehicleDetailsData.title
        self.descriptionLabel?.text = vehicleDetailsData.description
    }
}
