//
//  ForceUpdateAlertView.swift
//  FintechBase
//
//  Created by Sravani Madala on 04/01/24.
//

import UIKit

class ForceUpdateAlertView: UIView {

    @IBOutlet private weak var customView: UIView?
    @IBOutlet private weak var closeButton: UIButton?
    @IBOutlet private weak var updateButton: UIButton?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    
    var onClikButton: ((Int) -> Void)?
    
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
        self.setColor()
        self.setFont()
        self.setButton()
        self.customView?.addShadow(radius: 16)
    }
}

extension ForceUpdateAlertView {
   
    private func viewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryColor
        self.descriptionLabel?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x16)
        self.descriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
    }
    
    // MARK: set Button
    private func setButton() {
        self.closeButton?.tag = 1
        self.updateButton?.tag = 2
        self.updateButton?.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        self.closeButton?.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }

    // MARK: Update & Close Button Action
    @objc private func buttonAction(_ sender: UIButton) {
        self.onClikButton?(sender.tag)
    }
    
    // MARK: SetUp data
    func setUpData(data: ForceUpdateModel?) {
        self.titleLabel?.text = data?.title
        self.descriptionLabel?.text = data?.description
        self.closeButton?.isHidden = (data?.forceUpdateRequired ?? false) ? true : false
        self.updateButton?.setup(title: data?.buttonName, type: .primary, isEnabled: true)
    }
}
