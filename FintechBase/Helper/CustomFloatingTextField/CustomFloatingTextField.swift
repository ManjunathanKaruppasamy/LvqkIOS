//
//  DropDownTextfield.swift
//
//  Created by SENTHIL KUMAR on 11/07/22.
//

import UIKit

class CustomFloatingTextField: UIView {
    
    @IBOutlet weak var errorDescriptionView: UIView?
    @IBOutlet weak var contentTextfield: FloatingLabelTextField?
    @IBOutlet weak var dropDownCalenderView: UIView?
    @IBOutlet weak var dropDownCalenderImage: UIImageView?
    @IBOutlet weak var errorDescriptionLbl: UILabel?
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var erroriImage: UIImageView?
    @IBOutlet weak var dropDownCalenderButton: UIButton?
    @IBOutlet weak var imageViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint?
    @IBOutlet weak var imageWidth: NSLayoutConstraint?
    
    var onTextEditEnd: ((String) -> Void)?
    var onClickCustomAction: (() -> Void)?
    var didSelectDropDownOption: ((String, Int) -> Void)?
    var didSelectDate: ((String) -> Void)?
    var isStarText: Bool = false
    var starText = String()
    var selectTextType: SelectTextType?
    
    var datePicker: UIDatePicker!
    var dateFormate: DateFormate = .MMddyyyy
    var selectedEandD = ErrorAndDescription()
    var dropDownView: DropDownPopUpViewController?
    
    var dropDownList: [String] = []
    var headerName: String? = ""
    var currentVC: UIViewController?
    var datePickerView: UIView?
    var isCurrency: Bool = false
    var oldText = ""
    var onClearOptions: (() -> Void)?
    var checkTextField: ((String) -> Void)?
    var checkAtEndEdit: ((Bool) -> Void)?
    var dropDownWithImageList = [FastTagResultList]()
    var isOnlyTitleForDropdown: Bool = true
    
    lazy private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_\(countryISO)")
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    let myPicker: M2PDatePicker = {
        let dateView = M2PDatePicker()
        return dateView
    }()
    
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
extension CustomFloatingTextField {
    
    // MARK: Initial Load
    private func initialLoads() {
        setColor()
        setFont()
        contentTextfield?.delegate = self
        contentTextfield?.lineHeight = 1
        contentTextfield?.selectedLineHeight = 1
        setupField(selectType: .text, placeHolder: "")
    }
    
    // MARK: Color
    private func setColor() {
        contentTextfield?.textColor = .primaryColor
        contentTextfield?.lineColor = .lightDisableBackgroundColor
        contentTextfield?.selectedLineColor = .lightDisableBackgroundColor
        contentTextfield?.selectedTitleColor = .darkGreyDescriptionColor
        contentTextfield?.titleColor = .darkGreyDescriptionColor
    }
    
    // MARK: Font
    private func setFont() {
        contentTextfield?.titleFont = UIFont.setCustomFont(name: .regular, size: .x12)
        contentTextfield?.placeholderFont = UIFont.setCustomFont(name: .regular, size: .x12)
        contentTextfield?.font = UIFont.setCustomFont(name: .regular, size: .x18)
    }
    
    // MARK: TextField setup
    func setupField(selectType: SelectTextType, title: String? = nil, placeHolder text: String, drownDropData: DropDownContains? = nil, datePickerdata: DatePickerData? = nil, errorDescription: ErrorAndDescription? = nil) {
        self.isOnlyTitleForDropdown = drownDropData?.isOnlyTitle ?? true
        self.contentTextfield?.placeholder = text
        self.contentTextfield?.title = title
        if isOnlyTitleForDropdown {
            self.dropDownList = drownDropData?.dropDownArray  ?? []
        } else {
            self.dropDownWithImageList = drownDropData?.dropDownImageList ?? []
        }
        self.headerName = drownDropData?.headerName ?? ""
        self.currentVC = UIApplication.getTopViewController()// drownDropData?.parentView ?? parentContainerViewController()
        self.dateFormate = datePickerdata?.dateFormate ?? .MMddyyyy
        self.selectedEandD = errorDescription ?? selectedEandD
        self.selectTextType = selectType
        self.dropDownCalenderButton?.addTarget(self, action: #selector(dropDownOpenAction(_:)), for: .touchUpInside)
        self.contentTextfield?.addTarget(self, action: #selector(self.onTextFieldEditingChange), for: .editingChanged)
        self.setField(selectType: selectType)
        self.setErrorDescriptionView(errorDescription: errorDescription)
        
    }
    
    // MARK: Set Fields
    func setField (selectType: SelectTextType) {
        switch selectType {
        case .text:
            if isStarText {
                [dropDownCalenderButton, dropDownCalenderImage, dropDownCalenderView].forEach {
                    $0?.isHidden = false
                }
            } else {
                [dropDownCalenderButton, dropDownCalenderImage, dropDownCalenderView].forEach {
                    $0?.isHidden = true
                }
            }
            contentTextfield?.clearButtonMode = .whileEditing
            contentTextfield?.isUserInteractionEnabled = true
            imageViewTrailing.constant = 0
            [imageHeight, imageWidth].forEach {
                $0?.constant = 20
            }
            dropDownCalenderImage?.image = UIImage(named: Image.imageString.eyeClose)
        case .dropDown, .calender:
            [dropDownCalenderButton, dropDownCalenderImage, dropDownCalenderView].forEach {
                $0?.isHidden = false
            }
            contentTextfield?.clearButtonMode = .never
            contentTextfield?.isUserInteractionEnabled = false
            imageViewTrailing.constant = 0
            [imageHeight, imageWidth].forEach {
                $0?.constant = selectType == .dropDown ? 10 : 20
            }
            dropDownCalenderButton?.tag = selectType == .dropDown ? 1 : 2
            dropDownCalenderImage?.image = selectType == .dropDown ? UIImage(named: Image.imageString.dropdownDown) : UIImage(named: Image.imageString.calender)
        case .customeCalender:
            [dropDownCalenderButton, dropDownCalenderImage, dropDownCalenderView].forEach {
                $0?.isHidden = false
            }
            contentTextfield?.clearButtonMode = .never
            contentTextfield?.isUserInteractionEnabled = true
            imageViewTrailing.constant = 0
            [imageHeight, imageWidth].forEach {
                $0?.constant = selectType == .dropDown ? 10 : 25
            }
            dropDownCalenderButton?.tag = selectType == .dropDown ? 1 : 2
            dropDownCalenderImage?.image = selectType == .dropDown ? UIImage(named: Image.imageString.dropdownDown) : UIImage(named: Image.imageString.calender)
        }
    }
    
    // MARK: Set Error Description View
    func setErrorDescriptionView(errorDescription: ErrorAndDescription?) {
        switch errorDescription?.type {
        case .withDescription, .withBoth:
            errorDescriptionView?.isHidden = false
            erroriImage?.isHidden = true
            errorView?.isHidden = true
            errorDescriptionLbl?.font = UIFont.setCustomFont(name: .medium, size: .x10)
            errorDescriptionLbl?.textColor = .darkGreyDescriptionColor
            errorDescriptionLbl?.text = errorDescription?.description ?? ""
        case .withError:
            errorDescriptionLbl?.textColor = .redErrorColor
//            contentTextfield?.textColor = .redErrorColor
            errorView?.isHidden = true
            erroriImage?.isHidden = true
            errorDescriptionView?.isHidden = false
            errorDescriptionLbl?.font = UIFont.setCustomFont(name: .regular, size: .x12)
            errorDescriptionLbl?.text = errorDescription?.description ?? ""
        case .withNone, .none:
            errorDescriptionView?.isHidden = true
            erroriImage?.isHidden = true
            errorView?.isHidden = true
        }
    }
    
    @objc func onTextFieldEditingChange() {
        if self.isCurrency {
            var newText = contentTextfield?.text ?? ""
            if self.oldText.isEmpty {
                newText =  "\(rupeeSymbol) " + (newText)
            }
            
            newText = self.addCurrencyFormatting(for: newText)
            self.contentTextfield?.text = newText
            self.validateAmount(in: newText)
        }
        self.checkTextField?(contentTextfield?.text ?? "")
    }
    
    /* Amount Validation for Minimum and Maximum */
    private func validateAmount(in text: String) {
        
        var amount = text.replacingOccurrences(of: ",", with: "")
        amount = amount.replacingOccurrences(of: rupeeSymbol, with: "").trim
        
        if let doubleAmount = Double(amount) {
            guard doubleAmount > 0 else {
                return showSuccessToastMessage(message: AppLoacalize.textString.zeroAmountValidation, duration: 1)
            }
            
            let textVal = (isvkycStatusCompleted ? String(completedVKYCLimit) : String(pendingVKYCLimit))
            let dropedCurrenyText = textVal.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "")
            let formatted = self.formatter.string(from: NSNumber(value: Double(dropedCurrenyText) ?? 0))
            
            let actualLimit = doubleAmount > ((isvkycStatusCompleted ? completedVKYCLimit : pendingVKYCLimit) - walletBalance)
            
            if (isvkycStatusCompleted && actualLimit) || (!isvkycStatusCompleted && actualLimit) {
                
                showSuccessToastMessage(message: AppLoacalize.textString.walletBalanceMaximumLimit + (rupeeSymbol + " " + (formatted ?? "0")), messageColor: .white, bgColour: UIColor.redErrorColor)
                //            return false
            }
        }
    }
    
    /* Currency Formating EditValue */
    private func addCurrencyFormatting(for amount: String) -> String {
        
        if amount == "\(rupeeSymbol) " + "0" || amount.isEmpty {
            return "\(rupeeSymbol) " + "0"
        } else {
            let dropedCurrenyText = amount.dropFirst().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "")
            let numberVal = Double(dropedCurrenyText) ?? 0
            let formatted = self.formatter.string(from: NSNumber(value: numberVal))
            return "\(rupeeSymbol) " + (formatted ?? "0")
        }
    }
    
    @objc func dropDownOpenAction(_ sender: UIButton) {
        if isStarText && (self.selectTextType == .text) {
            if dropDownCalenderImage?.image == UIImage(named: Image.imageString.eyeClose) {
                contentTextfield?.text = starText
                dropDownCalenderImage?.image = UIImage(named: Image.imageString.eyeOpen)
            } else {
                var hashPassword = String()
                for _ in 0..<starText.count { hashPassword += "*" }
                contentTextfield?.text = hashPassword
                dropDownCalenderImage?.image = UIImage(named: Image.imageString.eyeClose)
            }
            
        } else {
            if sender.tag == 1 {
                dropDownCalenderImage?.image = UIImage(named: Image.imageString.dropdownUp)
                if !dropDownList.isEmpty || !dropDownWithImageList.isEmpty {
                    self.dropDownAction()
                } else {
                    self.onClickCustomAction?()
                }
            } else {
                if self.selectTextType == .calender {
                    if datePickerView == nil {
                        self.showDatePicker()
                    } else {
                        myPicker.isHidden = false
                    }
                } else {
                    self.onClickCustomAction?()
                }
            }
        }
    }
    
    // MARK: Hide Unhide Error
    func showError(with message: String) {
        errorDescriptionView?.isHidden = false
        erroriImage?.isHidden = false
        errorView?.isHidden = false
        errorDescriptionLbl?.font = UIFont.setCustomFont(name: .regular, size: .x10)
        errorDescriptionLbl?.textColor = .redErrorColor
        errorDescriptionLbl?.text = message
        contentTextfield?.errorMessage = NSLocalizedString(
            "error message",
            comment: "error message"
        )
        contentTextfield?.titleColor = .darkGreyDescriptionColor
        contentTextfield?.textColor = .redErrorColor
    }
    
    func hideErrorMessage() {
        if selectedEandD.type == .withBoth {
            errorDescriptionView?.isHidden = false
            erroriImage?.isHidden = true
            errorView?.isHidden = true
            errorDescriptionLbl?.font = UIFont.setCustomFont(name: .medium, size: .x10)
            errorDescriptionLbl?.textColor = .darkGreyDescriptionColor
            errorDescriptionLbl?.text = selectedEandD.description
        } else {
            errorDescriptionView?.isHidden = true
            erroriImage?.isHidden = true
            errorView?.isHidden = true
        }
        contentTextfield?.errorMessage = ""
        contentTextfield?.titleColor = .darkGreyDescriptionColor
        contentTextfield?.textColor = .primaryColor
    }
    
    // MARK: Show Drop Down
     func dropDownAction() {
         let bundle = Bundle(for: type(of: self))
         let dropDownView = DropDownPopUpViewController(nibName: Controller.ids.dropDownPopUpViewController, bundle: bundle)
         dropDownView.modalPresentationStyle = .overFullScreen
         self.dropDownView = dropDownView
         if isOnlyTitleForDropdown {
             dropDownView.dropDownArray = self.dropDownList
         } else {
             dropDownView.dropDownWithImageArray = self.dropDownWithImageList
             dropDownView.isOnlyOneTitle = false
         }
        dropDownView.headerName = headerName ?? ""
        dropDownView.dropDownListTableView?.reloadData()
        dropDownView.onClose = {
            self.dropDownCalenderImage?.image = UIImage(named: Image.imageString.dropdownDown)
        }
        dropDownView.selectedOption = { (selectedString, index) in
            self.dropDownCalenderImage?.image = UIImage(named: Image.imageString.dropdownDown)
            self.contentTextfield?.text = selectedString
            self.didSelectDropDownOption?(selectedString, index)
        }

         UIApplication.getTopViewController()?.present(dropDownView, animated: false)
    }
    
    // MARK: Show Date Picker
    private func showDatePicker() {
        
        myPicker.translatesAutoresizingMaskIntoConstraints = false
        self.currentVC?.view.addSubview(myPicker)
        self.datePickerView = myPicker
        guard let presentView = self.currentVC?.view else {
            return
        }
        NSLayoutConstraint.activate([
            myPicker.topAnchor.constraint(equalTo: presentView.topAnchor),
            myPicker.leadingAnchor.constraint(equalTo: presentView.leadingAnchor),
            myPicker.trailingAnchor.constraint(equalTo: presentView.trailingAnchor),
            myPicker.bottomAnchor.constraint(equalTo: presentView.bottomAnchor)
        ])
        
//        myPicker.dismissTapped = {
//            self.myPicker.isHidden = true
//        }
        myPicker.getSelectedDate = { date in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = self.dateFormate.rawValue
            let dateString = dateFormatter.string(from: date ?? Date())
            self.contentTextfield?.text = dateString
            self.didSelectDate?(dateString)
            self.myPicker.isHidden = true
        }
    }
}

// MARK: TextField Delegate
extension CustomFloatingTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == contentTextfield) && isStarText && (self.selectTextType == .text) {
            imageViewTrailing.constant = -20
            var hashPassword = String()
            let newChar = string.first ?? "-"
            let offsetToUpdate = starText.index(starText.startIndex, offsetBy: range.location)
            
            if string.isEmpty {
                starText.remove(at: offsetToUpdate)
                return true
            } else {
                starText.insert(newChar, at: offsetToUpdate)
            }
            if dropDownCalenderImage?.image == UIImage(named: Image.imageString.eyeClose) {
                for _ in 0..<starText.count { hashPassword += "*" }
                textField.text = hashPassword
                return false
            }
        }
        if self.isCurrency {
            /* Logic handled in EditValue Changed */
            guard let text = textField.text else {
                return false
            }
            
            var oldAmount = text.replacingOccurrences(of: ",", with: "")
            oldAmount = oldAmount.replacingOccurrences(of: rupeeSymbol, with: "").trim
            let newAmount = Double(oldAmount + string) ?? 0
            
            guard newAmount > 0 else {
                showSuccessToastMessage(message: AppLoacalize.textString.zeroAmountValidation, duration: 1)
                return false
            }
            
            let textVal = (isvkycStatusCompleted ? String(completedVKYCLimit) : String(pendingVKYCLimit))
                let dropedCurrenyText = textVal.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "")
                let formatted = self.formatter.string(from: NSNumber(value: Double(dropedCurrenyText) ?? 0))
            
            let actualLimit = newAmount > ((isvkycStatusCompleted ? completedVKYCLimit : pendingVKYCLimit) - walletBalance)
            
            if (isvkycStatusCompleted && actualLimit) || (!isvkycStatusCompleted && actualLimit) {
                
                showSuccessToastMessage(message: AppLoacalize.textString.walletBalanceMaximumLimit + (rupeeSymbol + " " + (formatted ?? "0")), messageColor: .white, bgColour: UIColor.redErrorColor)
                return false
            }
            let alphabet = CharacterSet(charactersIn: "1234567890").isSuperset(of: CharacterSet(charactersIn: string))
            let ranges = range.length + range.location > text.count
            
            if ranges == false && alphabet == false {
                return false
            }
            
            oldText = textField.text ?? ""
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if self.selectTextType == .text && !((contentTextfield?.text ?? "").isEmpty) {
            imageViewTrailing.constant = -20
        }
        if isStarText {
            [dropDownCalenderButton, dropDownCalenderImage, dropDownCalenderView].forEach {
                $0?.isHidden = false
            }
        } else {
            [dropDownCalenderButton, dropDownCalenderImage, dropDownCalenderView].forEach {
                $0?.isHidden = true
            }
        }
        
        if selectTextType == .customeCalender {
            onClickCustomAction?()
            [dropDownCalenderButton, dropDownCalenderImage, dropDownCalenderView].forEach {
                $0?.isHidden = false
            }
        }
        
        if self.isCurrency {
            if textField.text?.isEmpty ?? true {
                let newText = "\(rupeeSymbol) " + (textField.text ?? "")
                textField.text = newText
            }
            self.onClearOptions?()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.isCurrency {
            if let textVal = textField.text, textVal != "\(rupeeSymbol) ", !textVal.isEmpty {
                let dropedCurrenyText = textVal.dropFirst().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "")
                let formatted = self.formatter.string(from: NSNumber(value: Double(dropedCurrenyText) ?? 0))
                textField.text = "\(rupeeSymbol) " + (formatted ?? "0")
            }
        }
        if self.selectTextType == .text {
            imageViewTrailing.constant = 0
        }
        self.checkAtEndEdit?(true)
    }
}
