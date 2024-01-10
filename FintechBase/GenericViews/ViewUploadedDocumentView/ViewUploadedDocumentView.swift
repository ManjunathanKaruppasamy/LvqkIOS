//
//  ViewUploadedDocumentView.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 31/07/23.
//

import UIKit

class ViewUploadedDocumentView: UIView {
    @IBOutlet private weak var viewContent: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var documentImageView: UIImageView?
    @IBOutlet private weak var closeButton: UIButton?
    
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
extension ViewUploadedDocumentView {
    private func initialLoads() {
        self.setAction()
        self.setColor()
        self.setFont()
        self.viewContent?.layer.cornerRadius = 8
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = UIFont.setCustomFont(name: .regular, size: .x14)
    }
    
    // MARK: Set Action
    private func setAction() {
        self.closeButton?.setup(title: AppLoacalize.textString.close, type: .skip, skipButtonFont: UIFont.setCustomFont(name: .regular, size: .x16))
        self.closeButton?.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
    }
    // MARK: close Button Action
    @objc private func closeButtonAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    func setUpData(title: String, image: String) {
        self.titleLabel?.text = title
        self.documentImageView?.image = image.base64StringToImage()
    }
}
