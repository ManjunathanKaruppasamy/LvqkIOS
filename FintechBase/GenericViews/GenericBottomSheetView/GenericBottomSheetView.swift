//
//  GenericBottomSheetView.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 21/07/23.
//

import UIKit

class GenericBottomSheetView: UIView {

     @IBOutlet private weak var customView: UIView?
     @IBOutlet private weak var closeButton: UIButton?
     @IBOutlet private weak var topImage: UIImageView?
     @IBOutlet private weak var titleLabel: UILabel?
     @IBOutlet private weak var requestCallButton: UIButton?
     @IBOutlet private weak var descriptionLabel: UILabel?
     @IBOutlet private weak var continueClosureButton: UIButton?
    
    var onClickClose: ((Bool) -> Void)?
   
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: SetUp views
    private func setupView() {
        let view = viewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.customView?.layer.cornerRadius = 16
        self.setColor()
        self.setFont()
        self.setButton()
    }
    private func viewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view ?? UIView()
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .textBlackColor
        self.descriptionLabel?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.descriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x16)
    }
    // MARK: set Button
    private func setButton() {
        self.requestCallButton?.addTarget(self, action: #selector(requestCallButtonAction(_:)), for: .touchUpInside)
        self.continueClosureButton?.addTarget(self, action: #selector(continueForClosureAction(_:)), for: .touchUpInside)
        self.closeButton?.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: request call Button Action
    @objc private func requestCallButtonAction(_ sender: UIButton) {
        
    }
    
    // MARK: Cloure Button Action
    @objc private func continueForClosureAction(_ sender: UIButton) {
        
    }
    // MARK: Done & Close Button Action
    @objc private func closeButtonAction(_ sender: UIButton) {
        self.onClickClose?( true)
    }
}
