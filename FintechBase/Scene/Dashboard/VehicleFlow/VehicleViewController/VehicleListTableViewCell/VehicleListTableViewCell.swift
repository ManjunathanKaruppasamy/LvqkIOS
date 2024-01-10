//
//  VehicleListTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 14/03/23.
//

import UIKit

class VehicleListTableViewCell: UITableViewCell {

    @IBOutlet weak var staticFastTagIdLabel: UILabel?
    @IBOutlet weak var staticvehicleNumberLabel: UILabel?
    @IBOutlet weak var titleImageView: UIImageView?
    @IBOutlet weak var viewDetailsButton: UIButton?
    @IBOutlet weak var fastTagIdLabel: UILabel?
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var vehicleNumberLabel: UILabel?
    
    @IBOutlet weak var bgView: UIView?
    @IBOutlet weak var statusView: UIView?
    @IBOutlet weak var statusSwitch: UISwitch?
    @IBOutlet weak var statusLabel: UILabel?
    
    @IBOutlet weak var errorView: UIView?
    @IBOutlet weak var errorImage: UIImageView?
    @IBOutlet weak var errorDescriptionLabel: UILabel?
    
    @IBOutlet weak var blockView: UIView?
    @IBOutlet weak var blockImage: UIImageView?
    @IBOutlet weak var blockLabel: UILabel?
    
    var tapViewDetail: ((Int) -> Void)?
    var onClickSwitchToggle: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewContent?.layer.cornerRadius = 16
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: Initial Setup
extension VehicleListTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setColor()
        self.setFont()
        self.setButton()
        self.setLoacalise()
        self.errorView?.layer.cornerRadius = 10
        self.bgView?.layer.cornerRadius = 16
        self.viewContent?.addLightShadow()
    }
    
    // MARK: Color
    private func setColor() {
        self.staticFastTagIdLabel?.textColor = .midGreyColor
        self.staticvehicleNumberLabel?.textColor = .midGreyColor
        self.fastTagIdLabel?.textColor = .primaryColor
        self.vehicleNumberLabel?.textColor = .primaryColor
        self.errorDescriptionLabel?.textColor = .blusihGryColor
        self.blockLabel?.textColor = .redErrorColor
        self.statusSwitch?.onTintColor = .greenTextColor
        
    }
    // MARK: Font
    private func setFont() {
        self.staticFastTagIdLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.staticvehicleNumberLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.statusLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.fastTagIdLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
        self.vehicleNumberLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
        self.errorDescriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
        self.blockLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.staticFastTagIdLabel?.text = AppLoacalize.textString.fasTagSerialNumber
        self.staticvehicleNumberLabel?.text = AppLoacalize.textString.vehicleNumber
    }
    
    // MARK: Set Button
    private func setButton() {
        self.viewDetailsButton?.setup(title: AppLoacalize.textString.viewDetails, type: .skip, isEnabled: true)
        self.viewDetailsButton?.addTarget(self, action: #selector(viewDetailsButtonAction(_:)), for: .touchUpInside)
        self.statusSwitch?.addTarget(self, action: #selector(switchChanged(_:)), for: .touchUpInside)
        
    }
    // MARK: View Details Button Action
    @objc private func viewDetailsButtonAction(_ sender: UIButton) {
        self.tapViewDetail?(sender.tag)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        self.onClickSwitchToggle?(sender.tag)
    }
}

// MARK: Set Data
extension VehicleListTableViewCell {
    
    /* Configure Vehicle list View */
    func setupView(vehicleStatus: VehicleStatus, vehicleListResultArray: VehicleListResultArray) {
        self.statusSwitch?.isUserInteractionEnabled = false
        self.fastTagIdLabel?.text = vehicleListResultArray.serialNo ?? ""
        if (vehicleListResultArray.entityId ?? "").count > 10 {
            self.vehicleNumberLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x12)
            self.vehicleNumberLabel?.text = vehicleListResultArray.entityId ?? ""
        } else {
            self.vehicleNumberLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x14)
            self.vehicleNumberLabel?.text = vehicleListResultArray.entityId?.setVehicleFormate() ?? ""
        }
        
        switch vehicleStatus {
        case .active:
            self.viewDetailsButton?.isHidden = false
            self.statusView?.isHidden = false
            self.blockView?.isHidden = true
            self.errorView?.isHidden = true
            
            self.viewContent?.backgroundColor = .white
            self.statusLabel?.textColor = .greenTextColor
            self.statusLabel?.text = AppLoacalize.textString.active
            self.statusSwitch?.isOn = true
            self.statusSwitch?.onTintColor = .greenTextColor
            self.statusSwitch?.thumbTintColor = .white
            
        case .inActive:
            self.viewDetailsButton?.isHidden = false
            self.statusView?.isHidden = false
            self.blockView?.isHidden = true
            self.errorView?.isHidden = true
            
            self.viewContent?.backgroundColor = .white
            self.statusLabel?.textColor = .midGreyColor
            self.statusLabel?.text = AppLoacalize.textString.inActive
            self.statusSwitch?.isOn = false
            self.statusSwitch?.onTintColor = .greenTextColor
            self.statusSwitch?.thumbTintColor = .midGreyColor
            
        case .blocked:
            self.blockView?.isHidden = false
            self.errorView?.isHidden = false
            self.statusView?.isHidden = true
            self.viewDetailsButton?.isHidden = true
            
            self.blockLabel?.text = AppLoacalize.textString.blocklisted
            self.viewContent?.backgroundColor = .redErrorColor.withAlphaComponent(0.04)
        }
    }
}
