//
//  PaymentMethodView.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 28/07/23.
//

import UIKit

// Set view height as 270
class PaymentMethodView: UIView {

    @IBOutlet private weak var selectPaymentMethodLabel: UILabel?
    @IBOutlet private weak var upiMainView: UIView?
     
    @IBOutlet private weak var upiAppView: UIView?
    @IBOutlet private weak var upiAppTitle: UILabel?
    @IBOutlet private weak var upiAppDescription: UILabel?
    @IBOutlet private weak var upiAppImageView: UIImageView?
    @IBOutlet private weak var upiAppRightArrowImage: UIImageView?
    
    @IBOutlet private weak var dividerLineView: UIView?
    
    @IBOutlet private weak var otherPaymentView: UIView?
    @IBOutlet private weak var otherPaymentTitle: UILabel?
    @IBOutlet private weak var otherPaymentDescription: UILabel?
    @IBOutlet private weak var otherPaymentImageView: UIImageView?
    @IBOutlet private weak var otherPaymentRightArrowImage: UIImageView?
    
    var onTapPaymentView: ((Int) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        let view = viewFromNib()
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let view = view {
            self.addSubview(view)
        }
        self.initialLoads()
    }
    
    private func viewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
    
}

// MARK: Initial Set Up
extension PaymentMethodView {
    private func initialLoads() {
        self.setAction()
        self.setColor()
        self.setFont()
        self.setStaticText()
        self.upiMainView?.layer.cornerRadius = 16
    }
    
    // MARK: Color
    private func setColor() {
        self.selectPaymentMethodLabel?.textColor = .midGreyColor
        self.upiAppTitle?.textColor = .primaryColor
        self.upiAppDescription?.textColor = .greenColor
        self.otherPaymentTitle?.textColor = .textBlackColor
        self.otherPaymentDescription?.textColor = .redErrorColor
        self.upiMainView?.addLightShadow()
    }
    
    // MARK: Font
    private func setFont() {
        self.selectPaymentMethodLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.upiAppTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x16)
        self.upiAppDescription?.font = UIFont.setCustomFont(name: .regular, size: .x10)
        self.otherPaymentTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x16)
        self.otherPaymentDescription?.font = UIFont.setCustomFont(name: .regular, size: .x10)
    }
    
    // MARK: Static Text
    private func setStaticText() {
        self.selectPaymentMethodLabel?.text = AppLoacalize.textString.selectPaymentMethod
        self.upiAppTitle?.text = AppLoacalize.textString.payviaUPIApps
        self.upiAppDescription?.text = AppLoacalize.textString.noAdditionalChargesforUPItransactions
        self.otherPaymentTitle?.text = AppLoacalize.textString.otherPaymentOptions
        self.otherPaymentDescription?.text = AppLoacalize.textString.otherPaymentDescription
    }
    
    // MARK: Set Action
    private func setAction() {
        let upiAppViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(paymentViewTapped(tapGestureRecognizer:)))
        upiAppView?.isUserInteractionEnabled = true
        upiAppView?.tag = 1
        upiAppView?.addGestureRecognizer(upiAppViewTapGestureRecognizer)
        
        let otherPaymentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(paymentViewTapped(tapGestureRecognizer:)))
        otherPaymentView?.isUserInteractionEnabled = true
        otherPaymentView?.tag = 2
        otherPaymentView?.addGestureRecognizer(otherPaymentTapGestureRecognizer)
    }
    // MARK: Other Payment View Action - 1 / upi App View Action - 2
    @objc private func paymentViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let tag = tapGestureRecognizer.view?.tag {
            self.onTapPaymentView?(tag)
        }
    }
}
