//
//  VehicleDocumentViewController.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 01/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AVFoundation

protocol VehicleDocumentDisplayLogic: AnyObject {
    func displayFieldDetails(documentDetailsField: [DocumentDetailsField], instructionDetailsModel: InstructionDetailsModel?)
    func displayAddVehicleResponse(addVehicleParam: AddVehicleResponce)
}

class VehicleDocumentViewController: UIViewController {
    var interactor: VehicleDocumentBusinessLogic?
    var router: (NSObjectProtocol & VehicleDocumentRoutingLogic & VehicleDocumentDataPassing)?

    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var navigationView: UIView?
    @IBOutlet private weak var navigationTitle: UILabel?
    @IBOutlet private weak var submitButton: UIButton?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var uploadDocumentTableView: UITableView?
    
    private var documentDetailsField = [DocumentDetailsField]()
    private var instructionDetailsModel: InstructionDetailsModel?
    private var viewUploadedDocumentView = ViewUploadedDocumentView()
    
    var addVehicleResonse: AddVehicleResponce?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoad()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationView?.applyGradient(isVertical: true, colorArray: [.appDarkPinkColor, .appDarkBlueColor])
    }
}

// MARK: - Initial Setup
extension VehicleDocumentViewController {
    private func initialLoad() {
        self.navigationController?.isNavigationBarHidden = true
        self.setAction()
        self.setColor()
        self.setFont()
        self.setStaticText()
        self.setTableView()
        self.interactor?.getFieldDetails()
    }
    
    // MARK: Color
    private func setColor() {
        self.navigationTitle?.textColor = .white
        self.titleLabel?.textColor = .primaryButtonColor
        self.descriptionLabel?.textColor = .darkGreyDescriptionColor
    }
    
    // MARK: Font
    private func setFont() {
        self.navigationTitle?.font = UIFont.setCustomFont(name: .semiBold, size: .x18)
        self.titleLabel?.font = UIFont.setCustomFont(name: .semiBold, size: .x16)
        self.descriptionLabel?.font = UIFont.setCustomFont(name: .regular, size: .x12)
    }
    
    // MARK: Static Text
    private func setStaticText() {
        self.navigationTitle?.text = AppLoacalize.textString.vehicleVerification
        self.titleLabel?.text = AppLoacalize.textString.uploadDocuments
        self.descriptionLabel?.text = AppLoacalize.textString.acceptedFileFormats
    }
    
    // MARK: Set Action
    private func setAction() {
        self.submitButton?.setup(title: AppLoacalize.textString.continueText, type: .primary, isEnabled: false)
        self.backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        self.submitButton?.addTarget(self, action: #selector(submitButtonAction(_:)), for: .touchUpInside)
       
    }
    // MARK: Submit Button Action
    @objc private func submitButtonAction(_ sender: UIButton) {
        print("tapppedd")
        if AddVehicleData.sharedInstace.isChasis {
            if AddVehicleData.sharedInstace.isApplicantExist {
                AddVehicleData.sharedInstace.insurance = self.documentDetailsField[0].documentBase64Image ?? ""
            } else {
                AddVehicleData.sharedInstace.applicantPhoto = self.documentDetailsField[0].documentBase64Image ?? ""
                AddVehicleData.sharedInstace.insurance = self.documentDetailsField[1].documentBase64Image ?? ""
            }
        } else {
            if AddVehicleData.sharedInstace.isApplicantExist {
                AddVehicleData.sharedInstace.rcFront = self.documentDetailsField[0].documentBase64Image ?? ""
                AddVehicleData.sharedInstace.rcBack = self.documentDetailsField[1].documentBase64Image ?? ""
            } else {
                AddVehicleData.sharedInstace.applicantPhoto = self.documentDetailsField[0].documentBase64Image ?? ""
                AddVehicleData.sharedInstace.rcFront = self.documentDetailsField[1].documentBase64Image ?? ""
                AddVehicleData.sharedInstace.rcBack = self.documentDetailsField[2].documentBase64Image ?? ""
            }
        }
        
      //  self.interactor?.getAddVehicleData() // Calling this API in fast tag details page
        self.router?.routeToFastTagDetailVC()
    }
    
    // MARK: Back Button Action
    @objc private func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Tableview Setup
    private func setTableView() {
        self.uploadDocumentTableView?.register(UINib(nibName: Cell.identifier.uploadDocumentTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.uploadDocumentTableViewCell)
        self.uploadDocumentTableView?.register(UINib(nibName: Cell.identifier.instructionTableViewCell, bundle: nil), forCellReuseIdentifier: Cell.identifier.instructionTableViewCell)
        self.uploadDocumentTableView?.delegate = self
        self.uploadDocumentTableView?.dataSource = self
        self.uploadDocumentTableView?.separatorStyle = .none
    }
    
    // MARK: Present view Uploaded Document View
    private func presentviewUploadedDocumentView(title: String, image: String) {
        self.viewUploadedDocumentView = ViewUploadedDocumentView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height ))
        self.viewUploadedDocumentView.setUpData(title: title, image: image)
        self.view.addSubview(self.viewUploadedDocumentView)
    }
    
    // MARK: get Document Image
    private func getDocumentImage(index: Int) {
        self.showImage(with: { (image, titleName) in
            var imageObject = image
            if imageObject != nil, var imageData = imageObject?.pngData() {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                if let imageResized = imageObject?.resize(with: 0.1), let imageObjectData = imageResized.jpeg(.low) {
                        imageObject = imageResized
                        imageData = imageObjectData
                    }
                if let title = titleName, !title.isEmpty {
                    self.documentDetailsField[index].documentImageTitle = title
                } else {
                    self.documentDetailsField[index].documentImageTitle = "IMG_\(Date().getTimeStamp)"
                }
                
                self.documentDetailsField[index].documentBase64Image = imageData.base64EncodedString()
                self.uploadDocumentTableView?.reloadData()
                
            }
        })
        
    }
}

// MARK: tableView delegate - datasource
extension VehicleDocumentViewController: UITableViewDelegate, UITableViewDataSource {
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
            guard let cell: UploadDocumentTableViewCell = self.uploadDocumentTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.uploadDocumentTableViewCell, for: indexPath) as? UploadDocumentTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.setUPDocumentView(documentDetailsField: self.documentDetailsField[indexPath.row], index: indexPath.row)
            for documentDetailsArray in self.documentDetailsField {
                if let documentBase64Image = documentDetailsArray.documentBase64Image, !documentBase64Image.isEmpty {
                    self.submitButton?.setPrimaryButtonState(isEnabled: true)
                } else {
                    self.submitButton?.setPrimaryButtonState(isEnabled: false)
                    break
                }
            }
            cell.didSelectDropDownOption = { dropDownSelectedText in
                self.documentDetailsField[indexPath.row].selectedDocumentName = dropDownSelectedText
            }
            cell.uploadButtonTapped = { [weak self] (buttonTag, index) in
                guard let self = self else {
                    return
                }
                if buttonTag == 1 {
                    self.getDocumentImage(index: indexPath.row)
                } else if buttonTag == 2 {
                    let title = cell.customTextField?.contentTextfield?.text ?? ""
                    self.presentviewUploadedDocumentView(title: !title.isEmpty ? title : (self.documentDetailsField[indexPath.row].uploadDocumentTitle ?? ""), image: self.documentDetailsField[indexPath.row].documentBase64Image ?? "")
                } else {
                    self.documentDetailsField[index].documentImageTitle = nil
                    self.documentDetailsField[index].documentBase64Image = nil
                    self.uploadDocumentTableView?.reloadData()
                }
            }
            return cell
        case 1:
            guard let cell: InstructionTableViewCell = self.uploadDocumentTableView?.dequeueReusableCell(withIdentifier: Cell.identifier.instructionTableViewCell, for: indexPath) as? InstructionTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.instructionDetailsModel = self.instructionDetailsModel
            cell.instructionContentTableView?.reloadInMainThread()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return CGFloat(((self.instructionDetailsModel?.instructionContentArray.count ?? 0) * 35) + 75)
        } else {
            return UITableView.automaticDimension
        }
    }
}

// MARK: - <VehicleDocumentDisplayLogic> Methods
extension VehicleDocumentViewController: VehicleDocumentDisplayLogic {
    func displayFieldDetails(documentDetailsField: [DocumentDetailsField], instructionDetailsModel: InstructionDetailsModel?) {
        self.documentDetailsField = documentDetailsField
        self.instructionDetailsModel = instructionDetailsModel
        self.uploadDocumentTableView?.reloadInMainThread()
    }
    
    func displayAddVehicleResponse(addVehicleParam: AddVehicleResponce) {
        self.addVehicleResonse = addVehicleParam
        self.router?.routeToFastTagDetailVC()
    }
}
