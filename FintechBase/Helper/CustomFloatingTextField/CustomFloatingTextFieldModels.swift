//
//  CustomFloatingTextFieldModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 10/08/22.
//

import UIKit

// MARK: Date Formate
enum DateFormate: String {
    case EEEEMMMdyyyy = "EEEE, MMM d, yyyy"
    case MMddyyyy = "MM/dd/yyyy"
    case MMddyyyyHHmm = "MM-dd-yyyy HH:mm"
    case MMMdhmma = "MMM d, h:mm a"
    case MMMMyyyy = "MMMM yyyy"
    case MMMdyyyy = "MMM d, yyyy"
    case edMMMyyyyHHmmssZ = "E, d MMM yyyy HH:mm:ss Z"
    case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
    case ddMMyyyy = "dd/MM/yyyy"
    case HHmmssSSS = "HH:mm:ss.SSS"
    case dMMMyyyy = "dd MMMM yyyy"
    case ddMMMyyyy = "dd MMM yyyy"
    case yyyyMMdd = "yyyy-MM-dd"
    case ddmmyyyy = "dd-MM-yyyy"
    case ddMMMYY = "dd MMM yy"
    case MMMddYYYYHHmma = "MMM dd YYYY - HH:mm a"
    case ddMMyyyyHma = "dd/MM/yyyy hh:mm a"
    case MMMddyyyyhhmma = "MMM dd-yyyy '-' hh:mm a"
    case MMMddyyyyhhmmaComma = "MMM dd, yyyy '-' hh:mm a"
}

// MARK: Select Textfield Type
enum SelectTextType {
    case text
    case dropDown
    case calender
    case customeCalender
}

// MARK: Textfield Error/Description Type
enum ErrorAndDescriptioType {
    case withError
    case withDescription
    case withNone
    case withBoth
}

// MARK: Date Picker Data
struct DatePickerData {
    var dateFormate: DateFormate
    var presentVc: UIView
}

// MARK: Dropdown Data
struct DropDownContains {
    var dropDownArray: [String]?
    var dropDownImageList: [FastTagResultList]?
    var headerName: String?
    var isOnlyTitle: Bool?
    var parentView: UIViewController?
}

// MARK: Error/Description Data
struct ErrorAndDescription {
    var type: ErrorAndDescriptioType? = .withNone
    var description: String? = ""
}
