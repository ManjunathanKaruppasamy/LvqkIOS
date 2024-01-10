//
//  GetQWTagView.swift
//  FintechBase
//
//  Created by Sravani Madala on 02/08/23.
//

import Foundation
import UIKit

class GetQWTagView: UIView, UITextFieldDelegate {
   
    @IBOutlet private weak var customView: UIView?
    @IBOutlet private weak var verifyButton: UIButton?
    @IBOutlet private weak var regNumberLabel: UILabel?
    @IBOutlet private weak var chasisNumberLabel: UILabel?
    @IBOutlet private weak var titleNameLabel: UILabel?
    @IBOutlet weak var customTextfieldView: CustomFloatingTextField?
    @IBOutlet private weak var qwTagRegButton: UIButton?
    @IBOutlet private weak var qwTagChasisButton: UIButton?
    @IBOutlet private weak var closeButton: UIButton?
    
    var onClickClose: ((Bool) -> Void)?
    var isVerifiedVehicle: ((Bool) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        self.customTextfieldView?.contentTextfield?.delegate = self
        self.setTextFields(title: AppLoacalize.textString.registrationNumber, placeHolder: AppLoacalize.textString.regPlaceHolder, descStr: AppLoacalize.textString.regErrDescription)
        self.qwTagRegButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
        self.setLoacalise()
    }
    private func viewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view ?? UIView()
    }
    
    // MARK: Color
    private func setColor() {
        self.titleNameLabel?.textColor = .textBlackColor
        self.regNumberLabel?.textColor = .darkGreyDescriptionColor
        self.chasisNumberLabel?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Font
    private func setFont() {
        self.titleNameLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.regNumberLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
        self.chasisNumberLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
    }
    // MARK: set Button
    private func setButton() {
        self.verifyButton?.setup(title: AppLoacalize.textString.proceed, type: .primary, isEnabled: false)
        self.qwTagRegButton?.addTarget(self, action: #selector(qwTagRegButtonAction(_:)), for: .touchUpInside)
        self.qwTagChasisButton?.addTarget(self, action: #selector(qwTagChasisButtonAction(_:)), for: .touchUpInside)
        self.closeButton?.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        self.verifyButton?.addTarget(self, action: #selector(verifyButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.chasisNumberLabel?.text = AppLoacalize.textString.chasisNumber
        self.regNumberLabel?.text = AppLoacalize.textString.registrationNumber
    }
    
    // MARK: set TextField
    private func setTextFields(title: String, placeHolder: String, descStr: String) {
        
        self.customTextfieldView?.contentTextfield?.titleFont = UIFont.setCustomFont(name: .regular, size: .x14)
        self.customTextfieldView?.contentTextfield?.placeholderFont = UIFont.setCustomFont(name: .regular, size: .x14)
        self.customTextfieldView?.contentTextfield?.font = UIFont.setCustomFont(name: .regular, size: .x16)
        self.customTextfieldView?.contentTextfield?.titleColor = .textBlackColor
        self.customTextfieldView?.contentTextfield?.selectedTitleColor = .textBlackColor
        self.customTextfieldView?.setupField(selectType: .text, title: title, placeHolder: placeHolder)
        var errorContent = ErrorAndDescription()
        errorContent.type = .withDescription
        errorContent.description = descStr
        self.customTextfieldView?.setErrorDescriptionView(errorDescription: errorContent)
        self.customTextfieldView?.contentTextfield?.keyboardType = .numberPad
        self.customTextfieldView?.contentTextfield?.textColor = .textBlackColor
        self.customTextfieldView?.onClearOptions = {
        }
    }
    
    // MARK: request call Button Action
    @objc private func qwTagRegButtonAction(_ sender: UIButton) {
        self.qwTagRegButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
        self.qwTagChasisButton?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
        self.setTextFields(title: AppLoacalize.textString.registrationNumber, placeHolder: AppLoacalize.textString.regPlaceHolder, descStr: AppLoacalize.textString.regErrDescription)
        self.verifyButton?.setup(title: AppLoacalize.textString.proceed, type: .primary, isEnabled: true)
    }
    // MARK: request call Button Action
    @objc private func qwTagChasisButtonAction(_ sender: UIButton) {
        self.qwTagRegButton?.setImage(UIImage(named: Image.imageString.radioUnselect), for: .normal)
        self.qwTagChasisButton?.setImage(UIImage(named: Image.imageString.radioSelect), for: .normal)
        self.setTextFields(title: AppLoacalize.textString.chasisNumber, placeHolder: AppLoacalize.textString.chasisPlaceHolder, descStr: AppLoacalize.textString.chasisErrDescription)
        self.verifyButton?.setup(title: AppLoacalize.textString.proceed, type: .primary, isEnabled: true)
    }
    // MARK: request call Button Action
    @objc private func closeButtonAction(_ sender: UIButton) {
        self.onClickClose?( true)
    }
    // MARK: request call Button Action
    @objc private func verifyButtonAction(_ sender: UIButton) {
        self.isVerifiedVehicle?( true)
    }
}
