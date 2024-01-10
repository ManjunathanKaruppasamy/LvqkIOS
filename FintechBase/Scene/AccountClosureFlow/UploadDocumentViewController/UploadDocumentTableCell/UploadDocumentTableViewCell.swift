//
//  UploadDocumentTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 26/07/23.
//

import UIKit

class UploadDocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var customTextField: CustomFloatingTextField?
    @IBOutlet private weak var uploadDocumentTitleLabel: UILabel?
    @IBOutlet private weak var uploadDocumentView: UIView?
    @IBOutlet private weak var uploadButton: UIButton?
    @IBOutlet private weak var deleteDocumentButton: UIButton?
    @IBOutlet private weak var dividerLine: UIView?
    @IBOutlet private weak var documentNameLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    
    var uploadButtonTapped: ((_ buttonTag: Int, _ index: Int) -> Void)?
    var didSelectDropDownOption: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

// MARK: Initial SetUp
extension UploadDocumentTableViewCell {
    
    // MARK: Initial Loads
    private func initialLoads() {
        self.deleteDocumentButton?.isHidden = true
        self.descriptionLabel?.textColor = .midGreyColor
        self.uploadDocumentTitleLabel?.textColor = .midGreyColor
        self.documentNameLabel?.textColor = .lightDisableBackgroundColor
        self.descriptionLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.uploadDocumentTitleLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.documentNameLabel?.font = .setCustomFont(name: .regular, size: .x14)
        self.documentNameLabel?.text = AppLoacalize.textString.fileSizeMax
        self.uploadDocumentView?.setRoundedBorder(radius: 4, color: UIColor.lightDisableBackgroundColor.cgColor)
        self.uploadDocumentView?.layer.cornerRadius = 4
        self.uploadButton?.setup(title: AppLoacalize.textString.upload, type: .primary, isEnabled: false, primaryButtonSetup: PrimaryButtonSetup(cornerRadius: 4))
        self.uploadButton?.addTarget(self, action: #selector(uploadButtonAction(_:)), for: .touchUpInside)
        self.deleteDocumentButton?.addTarget(self, action: #selector(deleteDocumentButtonAction(_:)), for: .touchUpInside)
    }
    
    // MARK: Delete Document Button Action
    @objc private func deleteDocumentButtonAction(_ sender: UIButton) {
        self.uploadButtonTapped?(3, sender.tag)
    }
    
    // MARK: Upload Button Action
    @objc private func uploadButtonAction(_ sender: UIButton) {
        self.uploadButtonTapped?(self.uploadButton?.titleLabel?.text == AppLoacalize.textString.upload ? 1 : 2, sender.tag)
    }
    
    // MARK: Set Upload Document View
    func setUPDocumentView(documentDetailsField: DocumentDetailsField, index: Int, idProofTitle: String = "", addressProofTitle: String = "") {
        self.customTextField?.contentTextfield?.titleFont = UIFont.setCustomFont(name: .regular, size: .x12)
        self.customTextField?.contentTextfield?.placeholderFont = UIFont.setCustomFont(name: .regular, size: .x18)
        self.customTextField?.contentTextfield?.font = UIFont.setCustomFont(name: .regular, size: .x18)
        self.customTextField?.contentTextfield?.placeholderColor = .lightDisableBackgroundColor
        self.customTextField?.contentTextfield?.titleColor = .midGreyColor
        self.customTextField?.contentTextfield?.selectedTitleColor = .midGreyColor
        var filteredProof = documentDetailsField.dropDownArray?.filter { $0 != idProofTitle }
        filteredProof = filteredProof?.filter { $0 != addressProofTitle }
        self.customTextField?.setupField(selectType: .dropDown,
                                         title: documentDetailsField.isFieldRequired ? ((documentDetailsField.title ?? "") + " *") : documentDetailsField.title,
                                    placeHolder: documentDetailsField.placeholder,
                                         drownDropData: DropDownContains(dropDownArray: filteredProof, headerName: AppLoacalize.textString.selectProof, parentView: UIApplication.getTopViewController()))
        self.customTextField?.contentTextfield?.textColor = .primaryColor
        self.customTextField?.contentTextfield?.tag = index
        self.uploadButton?.tag = index
        self.deleteDocumentButton?.tag = index
        self.customTextField?.didSelectDropDownOption = { (selesctedText, index) in
            self.didSelectDropDownOption?(selesctedText)
        }
        self.customTextField?.isHidden = documentDetailsField.isTextFieldHide
        
        if let uploadDocumentDescription = documentDetailsField.uploadDocumentDescription, !uploadDocumentDescription.isEmpty {
            self.descriptionLabel?.isHidden = false
            self.descriptionLabel?.text = uploadDocumentDescription
        } else {
            self.descriptionLabel?.isHidden = !documentDetailsField.isTextFieldHide
            self.descriptionLabel?.isHidden = true
            self.descriptionLabel?.text = ""
        }
        
        if let uploadDocumentTitle = documentDetailsField.uploadDocumentTitle, !uploadDocumentTitle.isEmpty {
            self.uploadDocumentTitleLabel?.isHidden = false
            
            let titleString = NSMutableAttributedString(string: documentDetailsField.isFieldRequired ? (uploadDocumentTitle + " *") : uploadDocumentTitle)
            titleString.apply(color: UIColor.redErrorColor, subString: "*", textFont: .setCustomFont(name: .regular, size: .x12))
            
            self.uploadDocumentTitleLabel?.attributedText = titleString
        } else {
            self.uploadDocumentTitleLabel?.isHidden = true
            self.uploadDocumentTitleLabel?.text = ""
        }
        
        if documentDetailsField.isTextFieldHide && !documentDetailsField.isTextFieldDepend {
            self.uploadButton?.setPrimaryButtonState(isEnabled: true, primaryButtonSetup: PrimaryButtonSetup(cornerRadius: 4))
        } else {
            if let selectedDocumentName = documentDetailsField.selectedDocumentName, !selectedDocumentName.isEmpty {
                self.customTextField?.contentTextfield?.text = selectedDocumentName
                self.uploadButton?.setPrimaryButtonState(isEnabled: true, primaryButtonSetup: PrimaryButtonSetup(cornerRadius: 4))
            } else {
                self.customTextField?.contentTextfield?.text = ""
                self.uploadButton?.setPrimaryButtonState(isEnabled: false, primaryButtonSetup: PrimaryButtonSetup(cornerRadius: 4))
            }
        }
        
        if let documentImageTitle = documentDetailsField.documentImageTitle, !documentImageTitle.isEmpty {
            self.documentNameLabel?.text = documentImageTitle
            self.documentNameLabel?.textColor = .primaryColor
            self.uploadButton?.setTitle(AppLoacalize.textString.view, for: .normal)
            self.deleteDocumentButton?.isHidden = false
        } else {
            self.documentNameLabel?.text = AppLoacalize.textString.fileSizeMax
            self.documentNameLabel?.textColor = .lightDisableBackgroundColor
            self.uploadButton?.setTitle(AppLoacalize.textString.upload, for: .normal)
            self.deleteDocumentButton?.isHidden = true
        }
    }
}
