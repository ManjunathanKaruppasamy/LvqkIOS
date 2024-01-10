//
//  UIView+Extension.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//

import Foundation
import UIKit

extension UIView {
    
    /*Set Circle*/
    func circleRadius() {
        self.layer.cornerRadius = self.frame.size.height/2
    }
    
    /*Set Corner Radius for view*/
    func setCornerRadius(radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    /*Set Corner for selected Edge*/
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
    }
    
    /*Set Top Corners shadow */
    func addTopCornersShadow(radius: CGFloat) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = radius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 2
        self.superview?.addSubview(view)
        self.superview?.bringSubviewToFront(self)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.heightAnchor.constraint(equalToConstant: 20)
        ])
        self.layoutIfNeeded()
    }
    
    func setRoundedBorder(radius: CGFloat = 10, color: CGColor, width: CGFloat = 1) {
        layer.cornerRadius = radius
        layer.borderWidth = width
        layer.borderColor = color
    }
    
    func addShadow(radius: CGFloat = 0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 8
       // layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.cornerRadius = radius
    }
    
    func addLightShadow(radius: CGFloat = 0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0.259, green: 0.165, blue: 0.471, alpha: 0.04).cgColor
        self.layer.shadowOffset = CGSize(width: 4, height: 8)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 16
        self.layer.cornerRadius = radius
    }
    func animateShowDimmedView() {
        self.alpha = 1
        //        UIView.animate(withDuration: 0.3) {
        //            self.alpha = 0.8
        //        }
    }
    
    func animateDismissView(onTap: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { _ in
            if let onTap = onTap {
                onTap()
            }
        })
    }
    
    // MARK: Apply Gradient
    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            // top to bottom
            gradientLayer.locations = [0.0, 1.0]
            
        } else {
            // left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        }
        backgroundColor = .clear
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    /* Apply CrossDissolve Present Animation */
    func applyCrossDissolvePresentAnimation(animation: UIView.AnimationOptions = .curveEaseOut, duration: CGFloat = 0.5, delay: CGFloat = 0.3, fadeAlpha: CGFloat = 0.5) {
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: duration, delay: delay, options: animation, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(fadeAlpha)
        })
    }
    
    /* Apply CrossDissolve Dismiss Animation */
    func applyCrossDissolveDismissAnimation(animation: UIView.AnimationOptions = .curveEaseIn, duration: CGFloat = 0.15, delay: CGFloat = 0.0, fadeAlpha: CGFloat = 0.5, handler: @escaping (Bool) -> Void ) {
        
        self.backgroundColor = UIColor.black.withAlphaComponent(fadeAlpha)
        UIView.animate(withDuration: duration, delay: delay, options: animation, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        }, completion: { _ in
            handler(true)
        })
    }
}
