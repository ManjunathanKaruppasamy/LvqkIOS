//
//  TransactionTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 09/03/23.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var dividerLineView: UIView?
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var transactionImageView: UIImageView?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var amountLabel: UILabel?
    @IBOutlet weak var balanceValueLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension TransactionTableViewCell {
    // MARK: Initial Loads
    private func initialLoads() {
        self.setColor()
        self.setFont()
        
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryColor
        self.dateLabel?.textColor = .midGreyColor
        self.amountLabel?.textColor = .darkGreyDescriptionColor
        self.dividerLineView?.backgroundColor = .lightGreyTextColor
        self.balanceValueLabel?.textColor = .midGreyColor
    }
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.dateLabel?.font = UIFont.setCustomFont(name: .regular, size: .x10)
        self.amountLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.balanceValueLabel?.font = UIFont.setCustomFont(name: .regular, size: .x10)
    }
}

// MARK: Update Transaction history data
extension TransactionTableViewCell {
    /* Complete Transaction history data*/
    func updateTransactionHistoryData(data: TransactionHistoryArrayItem) {
        amountLabel?.textColor = data.type?.lowercased() == PaymentType.status.credit ? .greenTextColor : .redErrorColor
        self.titleLabel?.text = data.otherPartyName ?? (data.description ?? AppLoacalize.textString.notAvailable)
        self.dateLabel?.text = convertTimeStampToDate(date: data.created ?? 0, dateformat: DateFormate.MMMddyyyyhhmmaComma.rawValue)
        self.transactionImageView?.image = UIImage(named: (data.type?.lowercased() == PaymentType.status.credit ? Image.imageString.recharge : Image.imageString.toll))
        self.amountLabel?.text = (data.type?.lowercased() == PaymentType.status.credit ? "+ " : "- ") + "\(rupeeSymbol) " +  String(format: "%.2f", (data.amount ?? 0.00))
        let roundedBalance = data.balance?.roundToDecimal(2)
        self.balanceValueLabel?.text = "\(AppLoacalize.textString.balance) \(rupeeSymbol) " + String(format: "%.2f", roundedBalance ?? 0.00)
    }
    
    /* Complete Vehicle Transaction history data*/
    func updateVehicleTransactionHistoryData(data: VehicleTransactionArrayItem) {
        amountLabel?.textColor = data.type?.lowercased() == PaymentType.status.credit ? .greenTextColor : .redErrorColor
        self.titleLabel?.text = data.otherPartyName ?? (data.description ?? AppLoacalize.textString.notAvailable)
        self.dateLabel?.text = convertTimeStampToDate(date: data.time ?? 0, dateformat: DateFormate.MMMddyyyyhhmmaComma.rawValue)
        self.transactionImageView?.image = UIImage(named: (data.type?.lowercased() == PaymentType.status.credit ? Image.imageString.recharge : Image.imageString.toll))
        let amount = Double(data.amount ?? "0.00") ?? 0.00
        self.amountLabel?.text = (data.type?.lowercased() == PaymentType.status.credit ? "+ " : "- ") + "\(rupeeSymbol) " +  String(format: "%.2f", amount)
        let roundedBalance = data.balance?.roundToDecimal(2)
        self.balanceValueLabel?.text = "\(AppLoacalize.textString.balance) \(rupeeSymbol) " + String(format: "%.2f", roundedBalance ?? 0.00)
    }
}
 
