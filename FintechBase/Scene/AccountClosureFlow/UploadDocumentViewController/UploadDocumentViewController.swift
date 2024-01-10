//
//  UploadDocumentViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AVFoundation
import EDOLensSDK

protocol UploadDocumentDisplayLogic: AnyObject {
    func displayFieldDetails(documentDetailsField: [DocumentDetailsField])
}

class UploadDocumentViewController: UIViewController {
    var interactor: UploadDocumentBusinessLogic?
    var router: (NSObjectProtocol & UploadDocumentRoutingLogic & UploadDocumentDataPassing)?
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var walletBalanceView: UIView?
    @IBOutlet private weak var walletImageView: UIImageView?
    @IBOutlet private weak var staticRefundTitleLabel: UILabel?
    @IBOutlet private weak var balanceAmountLabel: UILabel?
    @IBOutlet private weak var staticDocumentDetailsTitleLabel: UILabel?
    @IBOutlet private weak var staticDocumentDescriptionTitleLabel: UILabel?
    @IBOutlet private weak var documentDetailsTableView: UITableView?
    
    private let selectedAmount = String(walletBalance)
    private var documentDetailsField = [DocumentDetailsField]()
    private var viewUploadedDocumentView = ViewUploadedDocumentView()
    private var idProofTitle = ""
    private var addressProofTitle = ""
    private var idProofIsExpand = true
    private var addressProofIsExpand = true
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoad()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.walletBalanceView?.layer.cornerRadius = 10
    }
}

// MARK: - Initial Setup
extension UploadDocumentViewController {
    private func initialLoad() {
        self.setFont()
        self.setColor()
        self.setLoacalise()
        self.setTableView()
        self.navigationController?.isNavigationBarHidden = true
        self.interactor?.getFieldDetails()
    }
    
    // MARK: Set Loacalise
    private func setLoacalise() {
        self.titleLabel?.text = AppLoacalize.textString.getYourAvailableWalletBalance
        self.staticRefundTitleLabel?.text = AppLoacalize.textString.refundableBalance
        self.staticDocumentDetailsTitleLabel?.text = AppLoacalize.textString.documentDetails
        self.staticDocumentDescriptionTitleLabel?.text = AppLoacalize.textString.documentDetailsDescription
        self.balanceAmountLabel?.text = rupeeSymbol + (selectedAmount).getRequiredFractionFormat()
    }
    
    // MARK: Font
    private func setFont() {
        self.titleLabel?.font = .setCustomFont(name: .semiBold, size: .x18)
        self.staticRefundTitleLabel?.font = .setCustomFont(name: .regular, size: .x14)
        self.staticDocumentDetailsTitleLabel?.font = .setCustomFont(name: .semiBold, size: .x16)
        self.staticDocumentDescriptionTitleLabel?.font = .setCustomFont(name: .regular, size: .x12)
        self.balanceAmountLabel?.font = .setCustomFont(name: .semiBold, size: .x18)
    }
    
    // MARK: Color
    private func setColor() {
        self.titleLabel?.textColor = .primaryColor
        self.staticRefundTitleLabel?.textColor = .midGreyColor
        self.staticDocumentDetailsTitleLabel?.textColor = .primaryButtonColor
        self.staticDocumentDescriptionTitleLabel?.textColor = .descriptionGreyColor.withAlphaComponent(0.5)
        self.balanceAmountLabel?.textColor = .primaryButtonColor
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.documentDetailsTableView?.register(UINib(nibName: Cell.identifier.uploadDocumentTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.uploadDocumentTableViewCell)
        self.documentDetailsTableView?.register(UINib(nibName: Cell.identifier.proceedCancelButtonTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.proceedCancelButtonTableViewCell)
        self.documentDetailsTableView?.delegate = self
        self.documentDetailsTableView?.dataSource = self
        self.documentDetailsTableView?.separatorStyle = .none
    }
    
    // MARK: Present view Uploaded Document View
    private func presentviewUploadedDocumentView(title: String, image: String) {
        self.viewUploadedDocumentView = ViewUploadedDocumentView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height ))
        self.viewUploadedDocumentView.setUpData(title: title, image: image)
        self.view.addSubview(self.viewUploadedDocumentView)
    }
    // MARK: get Document Image
    private func getDocumentImage(index: Int, type: String) {
        if type == "Aadhar Card" || type == "Pan Card" {
            EDOLens.shared.authKey = AUTHKEY
            EDOLens.shared.baseURL = digiLockBaseURL
            EDOLens.shared.docType = type == "Aadhar Card" ? .aadhaar : .pan
            EDOLens.shared.onCompletion = { isMasked, imgStr, type in
                guard isMasked else {
//                    print("Masking Failed")
                    showSuccessToastMessage(message: "Upload Failed!, Try Again", messageColor: .white, bgColour: UIColor.redErrorColor)
                    return
                }

                guard let fileUrl = URL(string: imgStr), let imgData = try? Data(contentsOf: fileUrl) else {
                    return
                }
                var imageObject = UIImage(data: imgData)
                var imageData = imageObject?.pngData()
                if let imageResized = imageObject?.resize(with: 0.25), let imageObjectData = imageResized.jpeg(.low) {
                    imageObject = imageResized
                    imageData = imageObjectData
                }

                self.documentDetailsField[index].documentImageTitle = "IMG_\(Date().getTimeStamp)"
                self.documentDetailsField[index].documentBase64Image = imageData?.base64EncodedString()
                self.documentDetailsTableView?.reloadData()
            }
            EDOLens.shared.present(from: self)
        } else {
            self.showImage(with: { (image, titleName) in
                var imageObject = image
                if imageObject != nil, var imageData = imageObject?.pngData() {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    if let imageResized = imageObject?.resize(with: 0.25), let imageObjectData = imageResized.jpeg(.low) {
                        imageObject = imageResized
                        imageData = imageObjectData
                    }
                    if let title = titleName, !title.isEmpty {
                        self.documentDetailsField[index].documentImageTitle = title
                    } else {
                        self.documentDetailsField[index].documentImageTitle = "IMG_\(Date().getTimeStamp)"
                    }
                    
                    self.documentDetailsField[index].documentBase64Image = imageData.base64EncodedString()
                    self.documentDetailsTableView?.reloadData()
                    
                }
            })
        }
        
    }
    
}

// MARK: tableView delegate - datasource
extension UploadDocumentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.documentDetailsField.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell: UploadDocumentTableViewCell = self.documentDetailsTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.uploadDocumentTableViewCell, for: indexPath) as? UploadDocumentTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.setUPDocumentView(documentDetailsField: self.documentDetailsField[indexPath.row], index: indexPath.row, idProofTitle: self.idProofTitle, addressProofTitle: self.addressProofTitle)
            cell.didSelectDropDownOption = { dropDownSelectedText in
                self.documentDetailsField[indexPath.row].selectedDocumentName = dropDownSelectedText
                let isBothSelected = dropDownSelectedText == "Pan Card" || dropDownSelectedText == "Passport"
                    indexPath.row == 1 ? (self.idProofIsExpand = isBothSelected ? false : (indexPath.row != 0 ? true : false)) : (indexPath.row == 3 ? (self.addressProofIsExpand = isBothSelected ? false : (indexPath.row != 0 ? true : false)) : print("nil"))
                self.documentDetailsField[indexPath.row].documentImageTitle = nil
                self.documentDetailsField[indexPath.row].documentBase64Image = nil
                if indexPath.row != 0 {
                    self.documentDetailsField[indexPath.row + 1].documentImageTitle = nil
                    self.documentDetailsField[indexPath.row + 1].documentBase64Image = nil
                    self.documentDetailsField[indexPath.row + 1].selectedDocumentName = dropDownSelectedText
                    if indexPath.row == 1 {
                        self.idProofTitle = dropDownSelectedText
                    } else {
                        self.addressProofTitle = dropDownSelectedText
                    }
                }
                if !self.idProofIsExpand {
                    self.documentDetailsField[2].documentBase64Image = "nil"
                }
                if !self.addressProofIsExpand {
                    self.documentDetailsField[4].documentBase64Image = "nil"
                }
                self.documentDetailsTableView?.reloadData()
            }
            cell.uploadButtonTapped = { [weak self] (buttonTag, index) in
                guard let self = self else {
                    return
                }
                let title = cell.customTextField?.contentTextfield?.text ?? ""
                if buttonTag == 1 {
                    self.getDocumentImage(index: indexPath.row, type: title)
                } else if buttonTag == 2 {
                    self.presentviewUploadedDocumentView(title: !title.isEmpty ? title : (self.documentDetailsField[indexPath.row].uploadDocumentTitle ?? ""),
                                                         image: self.documentDetailsField[indexPath.row].documentBase64Image ?? "")
                } else {
                    self.documentDetailsField[index].documentImageTitle = nil
                    self.documentDetailsField[index].documentBase64Image = nil
                    self.documentDetailsTableView?.reloadData()
                }
            }
            return cell
        case 1:
            guard let cell: ProceedCancelButtonTableViewCell = self.documentDetailsTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.proceedCancelButtonTableViewCell, for: indexPath) as? ProceedCancelButtonTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            var isEnable = false
            for documentDetailsArray in self.documentDetailsField {
                if let documentBase64Image = documentDetailsArray.documentBase64Image, !documentBase64Image.isEmpty {
                    isEnable = true
                } else {
                    isEnable = false
                    break
                }
            }
            cell.setUpButton(primaryButton: ButtonData(title: AppLoacalize.textString.uploadAndContinue, isEnable: isEnable), skipButton: ButtonData(title: AppLoacalize.textString.cancel, isEnable: true))
            cell.onClikButton = { buttonTag in
                if buttonTag == 1 {
                    if isMinKYC {
                        AccountClosureData.sharedInstace.bankProof = self.documentDetailsField[0].documentBase64Image ?? ""
                        AccountClosureData.sharedInstace.idProofFront = self.documentDetailsField[1].documentBase64Image ?? ""
                        AccountClosureData.sharedInstace.idProofBack = self.documentDetailsField[2].documentBase64Image ?? ""
                        AccountClosureData.sharedInstace.addressProofFront = self.documentDetailsField[3].documentBase64Image ?? ""
                        AccountClosureData.sharedInstace.addressProofBack = self.documentDetailsField[4].documentBase64Image ?? ""
                    } else {
                        AccountClosureData.sharedInstace.bankProof = self.documentDetailsField.first?.documentBase64Image ?? ""
                    }
                    self.router?.routeToOTPController()
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 135
        } else {
            return indexPath.row == 2 ? (idProofIsExpand ? UITableView.automaticDimension : 0) : (indexPath.row == 4 ? (addressProofIsExpand ? UITableView.automaticDimension : 0) : UITableView.automaticDimension)
        }
    }
}

// MARK: - <UploadDocumentDisplayLogic> Methods
extension UploadDocumentViewController: UploadDocumentDisplayLogic {
    func displayFieldDetails(documentDetailsField: [DocumentDetailsField]) {
        self.documentDetailsField = documentDetailsField
        self.documentDetailsTableView?.reloadInMainThread()
    }
}
