//
//  PermissionTableCell.swift

//
//  Created by CHANDRU on 25/07/22.
//

import UIKit

class PermissionTableCell: UITableViewCell {

    @IBOutlet weak var descLbl: UILabel?
    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var bottomLineView: UIView?
    
    var onClickSwitch: ((Int, Bool) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
        
    }
    
    // MARK: Initial Loads
    private func initialLoads() {
        if let descLbl = descLbl, let titleLbl = titleLbl {
            descLbl.font = .setCustomFont(name: .regular, size: .x12)
            titleLbl.font = .setCustomFont(name: .regular, size: .x16)
            titleLbl.textColor = .primaryColor
            descLbl.textColor = .darkGreyDescriptionColor
        }

    }
    
    // MARK: Set Data
    func setData(data: PermissionList) {
        titleLbl?.paragraphLineHeight(string: data.title ?? "", lineHeight: 1.24)
        descLbl?.text = data.description ?? ""
        imgView?.image = UIImage(named: data.image ?? "")
    }
}
