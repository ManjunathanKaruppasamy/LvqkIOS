//
//  String+Extension.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//

import Foundation
import UIKit

extension String {
    
    // MARK: PAN Validator
    func validatePANCardNumber() -> Bool {
        let regularExpression = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
        let panCardValidation = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return panCardValidation.evaluate(with: self)
    }
    
    // MARK: PAN Text Validator
    func isAllowPANText() -> Bool {
        let regex = "[A-Z0-9]{1,10}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return (pred.evaluate(with: self) || self.isEmpty)
    }
    
    // MARK: IFSC code validation
    func isValidIFSCCode() -> Bool {
        let regEx = "[A-Z]{4}[A-Z0-9]{1,7}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        return pred.evaluate(with: self)
    }
    
    // MARK: Email Validator
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    // MARK: Numeric Validator
    func isValidNumeric(with maxLimit: Int? = nil) -> Bool {
        let limit = maxLimit ?? 0
        let regex = "[0-9]\(limit == 0 ? "*" : "{1,\(limit)}")"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    // MARK: String with Aadhar format
    func formatAadharWithSpace() -> String {
        let appliedText = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mark = "XXXX XXXX XXXX"
        
        var result = ""
        var startIndex = appliedText.startIndex
        let endIndex = appliedText.endIndex
        
        for charct in mark where startIndex < endIndex {
            if charct == "X" {
                result.append(appliedText[startIndex])
                startIndex = appliedText.index(after: startIndex)
            } else {
                result.append(charct)
            }
        }
        return result
    }

    // MARK: Mobile Number formatting 123*****90
    func formatMobileNumber() -> String {
        String(self.enumerated().map { index, char in
            if self.count > 3 {
                return [0, 1, 2, self.count - 1, self.count - 2].contains(index) ? char : "*"
            } else {
                return "*"
            }
        })
    }
    
    // MARK: Set Space B/W Vehicle Number
    func setVehicleFormate() -> String {
        var outputString = ""
        if self.count == 10 {
            for (index, char) in self.enumerated() {
                if index <= 5 {
                    outputString += String(char) + ((index%2 != 0 && index != 0) ? " " : "")
                } else {
                    outputString += String(char)
                }
            }
            return outputString
        } else {
            return self
        }
    }
    
    func formatFasTagCardNumber(isAccountNo: Bool = false) -> String {
        let appliedText = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var mark = ""
        if isAccountNo {
            mark = "XXXX XXXX XXXX XXX"
        } else {
            mark = "XXXX xxxx xxxx XXXX"
        }
        var result = ""
        var startIndex = appliedText.startIndex
        let endIndex = appliedText.endIndex
        
        for charct in mark where startIndex < endIndex {
            if charct == "X" {
                result.append(appliedText[startIndex])
                startIndex = appliedText.index(after: startIndex)
            } else {
                result.append(charct)
            }
        }
        return result
    }
    
    // Base64 String to Image
    func base64ToImage() -> UIImage? {
        if let url = URL(string: self), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    // MARK: Decimal fraction formatting 0.000
    func getRequiredFractionFormat(minNoOfDigits: Int = 3, decimalDigits: Int = 2) -> String {
        String(format: "%\(minNoOfDigits).\(decimalDigits)f", Double(self) ?? 0.00)
    }
    
    func convertStringToBase64() -> String? {
        let base64String = self.data(using: .utf8)?.base64EncodedString()
        return base64String
    }
    func convertBase64ToString() -> String? {
        let decodedString = String(data: Data(base64Encoded: self) ?? Data(), encoding: .utf8)
        return decodedString
    }
    
    func base64StringToImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters), let image = UIImage(data: data) {
            return image
        }
        
        return nil
    }
}

extension String {
    func replace(string: String, replacement: String) -> String {
        self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        self.replace(string: " ", replacement: "")
    }
  }

extension String {
    
    // swiftlint: disable  force_try
    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match?.range ?? NSRange())
            let num = UInt8(byteString, radix: 16) ?? UInt8()
            data.append(num)
        }
        guard data.count > 0 else {
            return nil
        }
        return data
    }
    
}
