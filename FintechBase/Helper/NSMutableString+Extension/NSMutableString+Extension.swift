//
//  NSMutableString+Extension.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    func apply(color: UIColor, subString: String, textFont: UIFont = UIFont.setCustomFont(name: .semiBold, size: .x16), lineHeight: Double? = nil, alignment: NSTextAlignment = .left) {
        if let range = self.string.range(of: subString) {
            self.apply(color: color, onRange: NSRange(range, in: self.string), textFont: textFont, lineHeight: lineHeight, alignment: alignment)
        }
    }
    
    // Apply color on given range
    private func apply(color: UIColor, onRange: NSRange, textFont: UIFont, lineHeight: Double? = nil, alignment: NSTextAlignment = .left) {
        if lineHeight != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeight ?? 1.15
            paragraphStyle.alignment = alignment
            self.addAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: textFont, NSAttributedString.Key.paragraphStyle: paragraphStyle],
                               range: onRange)
        } else {
            self.addAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: textFont],
                               range: onRange)
        }
        
    }
    
    func applyUnderLineText(color: UIColor = UIColor.hyperLinkColor, subString: String, textFont: UIFont = UIFont.setCustomFont(name: .regular, size: .x16), textColor: UIColor = UIColor.hyperLinkColor) {
        if let onRange = self.string.range(of: subString) {
            let range = NSRange(onRange, in: self.string)
            
            addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range)
            addAttribute(NSAttributedString.Key.underlineColor, value: color, range: range)
            addAttributes([NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: textFont], range: range)
            //        return attributedString
        }
    }
}

extension UILabel {
    func paragraphLineHeight (string: String, lineHeight: Double, alignment: NSTextAlignment = .left) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = alignment
        let attributeString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        self.attributedText = attributeString
        
    }
    
    func countLines() -> Int {
      guard let myText = self.text as NSString? else {
        return 0
      }
      let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
      let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
      return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}

extension UITextView {
    func paragraphLineHeight (string: String, lineHeight: Double, alignment: NSTextAlignment = .left) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = alignment
        let attributeString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        self.attributedText = attributeString
        
    }
}
