//
//  VehicleDetailsCollectionViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/03/23.
//

import UIKit

class VehicleDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var roundView: UIView?
    @IBOutlet weak var statusLabel: UILabel?
    @IBOutlet weak var vehicleNameLabel: UILabel?
    @IBOutlet weak var vehicleNumberLabel: UILabel?
    @IBOutlet weak var rightArrowImg: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
}

extension VehicleDetailsCollectionViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setColor()
        self.setFont()
        self.viewContent?.layer.cornerRadius = 10
        self.roundView?.layer.cornerRadius = (self.roundView?.frame.height ?? 0)/2
    }
    
    // MARK: Color
    private func setColor() {
        self.statusLabel?.textColor = .greenTextColor
        self.vehicleNameLabel?.textColor = .midGreyColor
        self.vehicleNumberLabel?.textColor = .primaryColor
    }
    // MARK: Font
    private func setFont() {
        self.statusLabel?.font = UIFont.setCustomFont(name: .medium, size: .x10)
        self.vehicleNameLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.vehicleNumberLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
    }
    
    // MARK: Set Values
    func setValue(vehicleListResultArray: VehicleListResultArray) {
        self.vehicleNumberLabel?.text = vehicleListResultArray.entityId?.setVehicleFormate() ?? ""
        self.vehicleNameLabel?.text = (vehicleListResultArray.firstName ?? "") + (vehicleListResultArray.lastName ?? "")
        
        let vehicleStatus = CommonFunctions().getVehicleStatus(kitStatus: vehicleListResultArray.kitStatus ?? "")
        switch vehicleStatus {
        case .active:
            self.statusLabel?.textColor = .greenTextColor
            self.roundView?.backgroundColor = .greenTextColor
            self.statusLabel?.text = AppLoacalize.textString.activeCaps
            
        case .blocked:
            self.statusLabel?.textColor = .redErrorColor
            self.roundView?.backgroundColor = .redErrorColor
            self.statusLabel?.text = AppLoacalize.textString.blockedCaps
        default:
            self.statusLabel?.textColor = .midGreyColor
            self.roundView?.backgroundColor = .midGreyColor
            self.statusLabel?.text = AppLoacalize.textString.inActiveCaps
        }
    }
}
