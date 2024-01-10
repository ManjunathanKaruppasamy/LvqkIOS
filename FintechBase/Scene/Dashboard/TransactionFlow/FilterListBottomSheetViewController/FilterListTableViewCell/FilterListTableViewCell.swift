//
//  FilterListTableViewCell.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/03/23.
//

import UIKit
import IQKeyboardManagerSwift

class FilterListTableViewCell: UITableViewCell {

    @IBOutlet private weak var customDateView: UIView?
    @IBOutlet private weak var radioImageview: UIImageView?
    @IBOutlet private weak var filterTitleLbl: UILabel?
    @IBOutlet weak var dividerLine: UIView?
    @IBOutlet weak var toDateInputField: CustomFloatingTextField?
    @IBOutlet weak var fromDateInputField: CustomFloatingTextField?
    
    var datePresentView = UIView()
    private var isAlreadyEdited = false
    var selectedIndexCell: Int?
    var passDateValue: ((String, String, String, Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: Initial Set Up
extension FilterListTableViewCell {
    
    /* Initial loads */
    private func initialLoads() {
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        self.radioImageview?.image = UIImage(named: Image.imageString.radioUnselect)
        
        self.fromDateInputField?.contentTextfield?.placeholderFont = .setCustomFont(name: .regular, size: .x12)
        self.toDateInputField?.contentTextfield?.placeholderFont = .setCustomFont(name: .regular, size: .x12)
        
        self.fromDateInputField?.setupField(selectType: .customeCalender, title: AppLoacalize.textString.fromDate, placeHolder: AppLoacalize.textString.ddmmyyyy)
        self.toDateInputField?.setupField(selectType: .customeCalender, title: AppLoacalize.textString.toDate, placeHolder: AppLoacalize.textString.ddmmyyyy)
        
        self.fromDateInputField?.contentTextfield?.font = .setCustomFont(name: .regular, size: .x12)
        self.toDateInputField?.contentTextfield?.font = .setCustomFont(name: .regular, size: .x12)
        self.fromDateInputField?.onClickCustomAction = {
            self.clearFields()
            self.presentCalendar(isFromDate: true)
        }
        self.toDateInputField?.onClickCustomAction = {
            self.clearFields()
            self.presentCalendar(isFromDate: false)
        }
        
        self.fromDateInputField?.contentTextfield?.firstResponderFlag = .customDateTransaction
        self.toDateInputField?.contentTextfield?.firstResponderFlag = .customDateTransaction
    }
    
    // MARK: Set Date Filter Values
    func setDateFilterValues(titleString: String, isExpand: Bool, indexPathRow: Int) {
        self.filterTitleLbl?.text = titleString
        self.radioImageview?.image = self.selectedIndexCell == indexPathRow ? UIImage(named: Image.imageString.radioSelect) : UIImage(named: Image.imageString.radioUnselect)
        if isExpand && self.selectedIndexCell == indexPathRow {
            self.customDateView?.isHidden = false
            let fromDate = UserDefaults.standard.string(forKey: "FromDate") ?? ""
            let toDate = UserDefaults.standard.string(forKey: "Todate") ?? ""
            if !fromDate.isEmpty && !toDate.isEmpty {
                self.isAlreadyEdited = true
            }
            self.fromDateInputField?.contentTextfield?.text = fromDate
            self.toDateInputField?.contentTextfield?.text = toDate
        } else {
            self.isAlreadyEdited = false
            self.customDateView?.isHidden = true
        }
    }
    
    // MARK: Set FilterBy Values
    func setFilterByValues(titleString: String, indexPathRow: Int) {
        self.filterTitleLbl?.text = titleString
        self.radioImageview?.image = self.selectedIndexCell == indexPathRow ? UIImage(named: Image.imageString.radioSelect) : UIImage(named: Image.imageString.radioUnselect)
            self.customDateView?.isHidden = true
    }
    
    /* Clear Textfield */
    private func clearFields() {
        let fromDate = self.fromDateInputField?.contentTextfield?.text ?? ""
        let toDate = self.toDateInputField?.contentTextfield?.text ?? ""
        if self.isAlreadyEdited {
            if !fromDate.isEmpty  && !toDate.isEmpty {
                UserDefaults.standard.removeObject(forKey: "FromDate")
                UserDefaults.standard.removeObject(forKey: "Todate")
                self.fromDateInputField?.contentTextfield?.text = ""
                self.toDateInputField?.contentTextfield?.text = ""
            }
        }
    }
    
    /* Present Date Picker */
    private func presentCalendar(isFromDate: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        let fromeDate = UserDefaults.standard.string(forKey: "FromDate")
        let toDate = UserDefaults.standard.string(forKey: "Todate")
        let mini = dateFormatter.date(from: fromeDate ?? "")
        let max = dateFormatter.date(from: toDate ?? "")
        
        let viewHeight = self.datePresentView.frame.height
        if isFromDate {
            M2PDatePicker.shared.m2pAddDatePicker(backGroundColor: .white, textColor: .black, minDate: nil, maxDate: max != nil ? max : Date(), selectedDate: mini ?? Date(), height: (viewHeight/3))
        } else {
            M2PDatePicker.shared.m2pAddDatePicker(backGroundColor: .white, textColor: .black, minDate: mini, maxDate: Date(), selectedDate: max ?? Date(), height: (viewHeight/3))
        }
        
        M2PDatePicker.shared.getSelectedDate = { [weak self] date in
            self?.contentView.endEditing(true)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_GB")
            formatter.dateFormat = "yyyy-MM-dd"
            let dateValue = formatter.string(from: date ?? Date())
            if isFromDate {
                self?.fromDateInputField?.contentTextfield?.text = dateValue
                UserDefaults.standard.set(dateValue, forKey: "FromDate")
            } else {
                self?.toDateInputField?.contentTextfield?.text = dateValue
                UserDefaults.standard.set(dateValue, forKey: "Todate")
            }
            
            let fromDate = self?.fromDateInputField?.contentTextfield?.text ?? ""
            let toDate = self?.toDateInputField?.contentTextfield?.text ?? ""
            
            if !(fromDate.isEmpty) && !(toDate.isEmpty) {
                let dateObj1 = formatter.date(from: fromDate)
                let dateObj2 = formatter.date(from: toDate)
                formatter.dateFormat = "MMM d, yyyy"
                let date1 = formatter.string(from: dateObj1 ?? Date())
                let date2 = formatter.string(from: dateObj2 ?? Date())
                self?.passDateValue?("\(date1) - \(date2)", fromDate, toDate, false)
            } else {
                self?.passDateValue?("", fromDate, toDate, true)
            }
        }
    }
}
