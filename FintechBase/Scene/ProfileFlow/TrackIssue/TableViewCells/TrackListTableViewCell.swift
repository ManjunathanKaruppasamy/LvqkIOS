//
//  TrackListTableViewCell.swift
//  FintechBase
//
//  Created by Manjunathan Karuppasamy on 07/03/23.
//

import UIKit

class TrackListTableViewCell: UITableViewCell {
    @IBOutlet private weak var reasonTitleLabel: UILabel?
    @IBOutlet private weak var amountLabel: UILabel?
    @IBOutlet private weak var dateLabel: UILabel?
    @IBOutlet private weak var statusView: UIView?
    @IBOutlet private weak var trackNumberLabel: UILabel?
    @IBOutlet private weak var issueNumberLabel: UILabel?
    @IBOutlet private weak var statusLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initilizeUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.backgroundColor = .white
        self.contentView.addLightShadow()
    }
}

// MARK: Initial loads
extension TrackListTableViewCell {
    
    // MARK: initilizeUI
    private func initilizeUI() {
        
        [reasonTitleLabel, amountLabel].forEach {
            $0?.textColor = .primaryColor
            $0?.font = .setCustomFont(name: .semiBold, size: .x14)
            $0?.numberOfLines = 0
        }
        
        [trackNumberLabel, issueNumberLabel].forEach {
            $0?.textColor = .gray2
            $0?.font = .setCustomFont(name: .regular, size: .x10)
        }
        
        [dateLabel].forEach {
            $0?.textColor = .gray3
            $0?.font = .setCustomFont(name: .regular, size: .x10)
        }
        
        [statusView].forEach {
            $0?.backgroundColor = .reddishBg
            $0?.setCornerRadius(radius: 8)
        }
        
        [statusLabel].forEach {
            $0?.textColor = .lightBlack
            $0?.font = .setCustomFont(name: .regular, size: .x10)
        }
        
    }
}

// MARK: Set TrackListData
extension TrackListTableViewCell {
    
    // MARK: Configure TrackListData
    func configureTrackListData(data: DisputeEntityResult) {
        let title = data.description ?? ""
        reasonTitleLabel?.text = data.description?.isEmpty ?? true ? AppLoacalize.textString.notAvailable : title
        let amount = data.amount ?? AppLoacalize.textString.zeroAmount
        amountLabel?.text = "\(rupeeSymbol) " + amount
        statusLabel?.text = data.reason ?? AppLoacalize.textString.notAvailable
//        dateLabel?.text = convertMilliSecondsToReqDateFormat(milliseconds: data.created ?? 0, dateformat: DateFormate.ddMMMYY.rawValue)
        dateLabel?.text = convertTimeStampToDate(date: data.created ?? 0, dateformat: DateFormate.ddMMMYY.rawValue)
        
        let transactionNumber = data.extTxnId ?? AppLoacalize.textString.notAvailable
        trackNumberLabel?.text = transactionNumber == AppLoacalize.textString.notAvailable ? "\(transactionNumber)"  : "\(AppLoacalize.textString.transactionString) #\(transactionNumber)"
        let issueNumber = data.disputeRef ?? AppLoacalize.textString.notAvailable
        issueNumberLabel?.text = issueNumber == AppLoacalize.textString.notAvailable ? issueNumber : "\(AppLoacalize.textString.issue) #\(issueNumber)"
    }
}
