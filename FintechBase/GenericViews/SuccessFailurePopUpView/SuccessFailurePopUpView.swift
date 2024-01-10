//
//  SuccessFailurePopUpView.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 03/03/23.
//

import UIKit

struct SuccessFailurePopUpViewModel {
    var title: String
    var description: String
    var image: String
    var primaryButtonTitle: String?
    var isCloseButton: Bool = false
}

class SuccessFailurePopUpView: UIView {

    @IBOutlet weak var descriptionLbl: UILabel?
    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet weak var succesImageview: UIImageView?
    @IBOutlet weak var viewContent: UIView?
    @IBOutlet weak var doneButton: UIButton?
    @IBOutlet weak var closeButton: UIButton?
    @IBOutlet weak var doneButtonConstraint: NSLayoutConstraint?
    
    var onClickClose: ((Bool) -> Void)?
    
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
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.viewContent?.layer.cornerRadius = 16
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
        self.titleLbl?.textColor = .primaryColor
        self.descriptionLbl?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLbl?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.descriptionLbl?.font = UIFont.setCustomFont(name: .regular, size: .x16)
    }
    
    // MARK: set Button
    private func setButton() {
        self.doneButton?.tag = 1
        self.closeButton?.tag = 2
        self.doneButton?.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        self.closeButton?.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: Done & Close Button Action
    @objc private func buttonAction(_ sender: UIButton) {
        // tag = 1 -> doneButton
        // tag = 2 -> closeButton
        self.onClickClose?( sender.tag == 1 ? false : true)
    }
    
    // MARK: Fill data
    func setUpData(data: SuccessFailurePopUpViewModel) {
        self.doneButton?.isUserInteractionEnabled = false
        self.doneButtonConstraint?.constant = 0
        
        self.titleLbl?.text = data.title
        self.descriptionLbl?.text = data.description
        self.succesImageview?.image = UIImage(named: data.image)
        self.closeButton?.isHidden = data.isCloseButton ? false : true
        
        if let doneButton = data.primaryButtonTitle {
            self.doneButton?.isUserInteractionEnabled = true
            self.doneButtonConstraint?.constant = 55
            self.doneButton?.setup(title: doneButton, type: .primary)
        }
            
    }

}
