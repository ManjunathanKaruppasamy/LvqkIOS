//
//  OTPTextField.swift
//  M2PSDK
//
//  Created by SENTHIL KUMAR on 07/11/22.
//

import Foundation
import UIKit

@objc class OTPTextField: UITextField {
    /// Border color info for field
    public var otpBorderColor: UIColor = UIColor.black
    
    /// Border width info for field
    public var otpBorderWidth: CGFloat = 2
    
    public var shapeLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setText(value: String) {
        text = value
    }
    
    public func initalizeUI(forFieldType type: DisplayType) {
        switch type {
        case .circular:
            layer.cornerRadius = bounds.size.width / 2
        case .roundedCorner:
            layer.cornerRadius = 8
        case .square:
            layer.cornerRadius = 0
        case .diamond:
            addDiamondMask()
        case .underlinedBottom:
            addBottomView()
        }
        
        // Basic UI setup
        if type != .diamond && type != .underlinedBottom {
            layer.borderColor = otpBorderColor.cgColor
            layer.borderWidth = otpBorderWidth
        }
        
        autocorrectionType = .no
        textAlignment = .center
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        
        _ = delegate?.textField?(self, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "")
    }
    
    // Helper function to create diamond view
    fileprivate func addDiamondMask() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.size.width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height / 2.0))
        path.addLine(to: CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.size.height / 2.0))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        layer.mask = maskLayer
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = otpBorderWidth
        shapeLayer.fillColor = backgroundColor?.cgColor
        shapeLayer.strokeColor = otpBorderColor.cgColor
        
        layer.addSublayer(shapeLayer)
    }
    
    // Helper function to create a underlined bottom view
    fileprivate func addBottomView() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        path.close()
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = otpBorderWidth
        shapeLayer.fillColor = backgroundColor?.cgColor
        shapeLayer.strokeColor = otpBorderColor.cgColor
        
        layer.addSublayer(shapeLayer)
    }
    
}
