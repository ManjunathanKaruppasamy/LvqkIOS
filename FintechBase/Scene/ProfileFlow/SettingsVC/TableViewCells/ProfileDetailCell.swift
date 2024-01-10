//
//  ProfileDetailCell.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 02/03/23.
//

import UIKit

class ProfileDetailCell: UITableViewCell {
    @IBOutlet private weak var bgView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet weak var biometricSwitch: UISwitch?
    @IBOutlet private weak var arrowImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

// MARK: Initial loads
extension ProfileDetailCell {
    
    private func setupUI() {
        
        [self.biometricSwitch].forEach {
            $0?.onTintColor = .greenColor
        }
        [self.titleLabel].forEach {
            $0?.font = .setCustomFont(name: .regular, size: .x14)
            $0?.textColor = .primaryColor
        }
        
        [self.bgView].forEach {
            $0?.setCornerRadius(radius: 10.0)
           // $0?.backgroundColor = .whitebackgroundColor
        }
        
        [arrowImageView].forEach {
            $0?.image = UIImage(named: Image.imageString.rightArrow)
        }
    }
}

// MARK: Configure TableViewCell data
extension ProfileDetailCell {
    
    func updateProfileListData(data: ProfileItem?) {
        if let value = data {
            self.titleLabel?.text = value.name.description
            self.biometricSwitch?.isHidden = !value.switchEnable
            self.arrowImageView?.isHidden = value.switchEnable
        }
        biometricEnabled ? (biometricSwitch?.isOn = true) : (biometricSwitch?.isOn = false)
    }
}
