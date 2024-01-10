//
//  FastTagPaymentCell.swift
//  FintechBase
//
//  Created by Sravani Madala on 03/08/23.
//

import UIKit

class FastTagPaymentCell: UITableViewCell {

    @IBOutlet private weak var customPaymentView: PaymentMethodView?
    
    var onClickPayment: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.customPaymentView?.roundCorners(corners: [.topLeft, .topRight], radius: 16)
        }
    }
    
    private func initialLoads() {
        getPaymentMethod()
    }
    
    // MARK: get Payment Method
    private func getPaymentMethod() {
        self.customPaymentView?.onTapPaymentView = { viewTag in
            self.onClickPayment?(viewTag)
        }
    }
}
