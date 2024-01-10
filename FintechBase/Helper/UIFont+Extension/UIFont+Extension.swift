//
//  UIFont+Extension.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//

import Foundation
import UIKit

/*Custom font type*/
enum FontType: String {
    case regular = "Rubik-Regular"
    case medium = "Rubik-Medium"
    case semiBold = "Rubik-SemiBold"
    case bold = "Rubik-Bold"
    case light = "Rubik-Light"
}

/*Custom font size*/
// swiftlint: disable identifier_name
enum FontSize: CGFloat {
    case x8 = 8.0
    case x10 = 10.0
    case x12 = 12.0
    case x14 = 14.0
    case x16 = 16.0
    case x18 = 18.0
    case x20 = 20.0
    case x22 = 22.0
    case x24 = 24.0
    case x26 = 26.0
    case x28 = 28.0
    case x30 = 30.0
    case x32 = 32.0
    case x34 = 34.0
}

/*Set Custom font and size*/
extension UIFont {
    class func setCustomFont(name: FontType, size: FontSize) -> UIFont {
        UIFont(name: name.rawValue, size: size.rawValue) ?? UIFont.systemFont(ofSize: 16)
    }
    
}
