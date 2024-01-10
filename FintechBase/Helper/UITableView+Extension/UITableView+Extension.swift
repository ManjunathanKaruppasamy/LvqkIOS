//
//  UITableView+Extension.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/03/23.
//

import Foundation
import UIKit

extension UITableView {
    
    func scrollToBottom(isAnimated: Bool = false) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection: self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
         indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    /*Reload Table in Mainthread*/
    func reloadInMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    // MARK: Screenshot UITableView
    func takeScrollableViewScreenShot() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, 0)
        
        let savedContentOffset = self.contentOffset
        let savedFrame = self.frame
        
        self.contentOffset = CGPoint.zero
        self.layer.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        self.layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        self.contentOffset = savedContentOffset
        self.frame = savedFrame
        UIGraphicsEndImageContext()
        return image
    }
}
