//
//  UIColor+Extension.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hex string: String, alpha: CGFloat = 1.0) {
        var hex = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        if hex.count < 3 {
            hex = "\(hex)\(hex)\(hex)"
        }
        
        if hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil {
            if hex.count == 3 {
                let startIndex = hex.index(hex.startIndex, offsetBy: 1)
                let endIndex = hex.index(hex.startIndex, offsetBy: 2)
                
                let redHex = String(hex[..<startIndex])
                let greenHex = String(hex[startIndex ..< endIndex])
                let blueHex = String(hex[endIndex...])
                
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            
            let startIndex = hex.index(hex.startIndex, offsetBy: 2)
            let endIndex = hex.index(hex.startIndex, offsetBy: 4)
            let redHex = String(hex[..<startIndex])
            let greenHex = String(hex[startIndex ..< endIndex])
            let blueHex = String(hex[endIndex...])
            
            var redInt: CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt: CUnsignedInt = 0
            
            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0,
                      green: CGFloat(greenInt) / 255.0,
                      blue: CGFloat(blueInt) / 255.0,
                      alpha: CGFloat(alpha))
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
    
    var hexValue: String {
        var color = self
        guard let component = color.cgColor.components else {
            return ""
        }
        if color.cgColor.numberOfComponents < 4 {
            color = UIColor(red: component[0], green: component[0], blue: component[0], alpha: component[1])
        }
        if let colorSpace = color.cgColor.colorSpace, colorSpace.model != .rgb {
            return "#FFFFFF"
        }
        return String(format: "#%02X%02X%02X",
                      Int(component[0] * 255.0),
                      Int(component[1] * 255.0),
                      Int(component[2] * 255.0))
    }
}

// MARK: - Colors

extension UIColor {
    
    static var primaryColor: UIColor {
        UIColor(hex: "18093B")
    }
    
    static var secondaryColor: UIColor {
        UIColor(hex: "E02478")
    }
    
    static var hyperLinkColor: UIColor {
        UIColor(hex: "3E4DED")
    }
    
    static var darkGreyDescriptionColor: UIColor {
        UIColor(hex: "5B5A5E")
    }
    
    static var backgroundColor: UIColor {
        UIColor(hex: "C7C7C7")
    }
    
    static var plainBGColor: UIColor {
        UIColor(hex: "F7F7F9")
    }
    
    static var lightDisableBackgroundColor: UIColor {
        UIColor(hex: "E1E1E6")
    }
    
    static var midGreyColor: UIColor {
        UIColor(hex: "4E5061")
    }
    
    static var primaryButtonColor: UIColor {
        UIColor(hex: "422A78")
    }
    
    static var blusihGryColor: UIColor {
        UIColor(hex: "60708F")
    }
    
    static var redErrorColor: UIColor {
        UIColor(hex: "DB092F")
    }
    
    static var blackTextColor: UIColor {
        UIColor(hex: "030303")
    }
    
    static var secondaryBlackTextColor: UIColor {
        UIColor(hex: "2C2C40")
    }
    
    static var lightGreyTextColor: UIColor {
        UIColor(hex: "F5F5F5")
    }
    
    static var greenTextColor: UIColor {
        UIColor(hex: "008A17")
    }
    
    static var appDarkPinkColor: UIColor {
        UIColor(hex: "890159")
        
    }
    
    static var appDarkBlueColor: UIColor {
        UIColor(hex: "270072")
    }
    
    static var brownishRedColor: UIColor {
        UIColor(hex: "B26D79")
    }
    
    static var blueColor: UIColor {
        UIColor(hex: "0076D6")
    }
    
    static var orangeColor: UIColor {
        UIColor(hex: "E5A109")
    }
    
    static var textLightGray: UIColor {
        UIColor(hex: "6E6E6E")
    }
    
    static var darkBlack: UIColor {
        UIColor(hex: "000000")
    }
    
    static var gray2: UIColor {
        UIColor(hex: "9F9F9F")
    }
    
    static var gray3: UIColor {
        UIColor(hex: "777777")
    }
    
    static var reddishBg: UIColor {
        UIColor(hex: "FAEDEF")
    }
    
    static var lightBlack: UIColor {
        UIColor(hex: "111111")
    }
    
    static var hyperLinK: UIColor {
        UIColor(hex: "3E4DED")
    }
    
    static var statusBarColor: UIColor {
        UIColor(hex: "5F0F46")
    }
    
    static var whitebackgroundColor: UIColor {
        UIColor(hex: "F3F3F6")
    }
    
    static var greenColor: UIColor {
        UIColor(hex: "008A17")
    }
    
    static var textBlackColor: UIColor {
        UIColor(hex: "151515")
    }
    
    static var descriptionGreyColor: UIColor {
        UIColor(hex: "222222")
    }
    
}
