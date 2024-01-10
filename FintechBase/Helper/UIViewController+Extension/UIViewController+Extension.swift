//
//  UIViewController+Extension.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 19/07/22.
//

import Foundation
import UIKit
import Photos

fileprivate var imageCompletion: ((UIImage?, String?) -> Void)?
/** Extension to show Generic Message Alert Controller throughout the App **/
extension UIViewController {
    
    enum AlertTitle: String {
        case success = "Success"
        case error = "Error"
        case alert = "Alert"
    }
    
    func showMessageAlert(title: String = AlertTitle.error.rawValue, message: String?,
                          showRetry: Bool = true, retryTitle: String? = nil,
                          showCancel: Bool = true, cancelTitle: String? = nil,
                          onRetry: (() -> Void)?, onCancel: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if showRetry {
                alertController.addAction(UIAlertAction(title: retryTitle ?? "Retry",
                                                        style: .default, handler: { (retry) in
                    guard let onRetry = onRetry else {
                        return
                    }
                    onRetry()
                }))
            }
            if showCancel {
                alertController.addAction(UIAlertAction(title: cancelTitle ?? "Cancel",
                                                        style: .cancel, handler: { (cancel) in
                    guard let onCancel = onCancel else {
                        return
                    }
                    onCancel()
                }))
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func alertWithNoAction(title: String = "", delay: Int = 2, completion: @escaping ((_ success: Bool) -> Void)) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(alertController, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay)) {
                    alertController.dismiss(animated: true, completion: nil)
                    completion(true)
                }
            }
        }
    }
    
    // MARK: Dismiss ViewController
    func dismissVC() {
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    // MARK: Dismiss ViewController
    func popToViewController(destination: AnyClass) {
        for controller in self.navigationController?.viewControllers ?? [] {
            if controller.isKind(of: destination) { self.navigationController?.popToViewController(controller, animated: true) }
        }
    }
    // MARK: Get Date From String
    func getDateFromString(dateString: String, formate: DateFormate = .ddMMyyyy) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate.rawValue
        let date = dateFormatter.date(from: dateString)
        return date
    }
    
    // MARK: Get String From Date
    func getStringFromDate(date: Date, formate: DateFormate = .ddMMyyyy) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate.rawValue
        let dateString = dateFormatter.string(from: date )
        return dateString
    }
    // MARK: Show Image Selection Action Sheet
    
    func showImage(with completion: @escaping ((UIImage?, String?) -> Void)) {
        
        let alert = UIAlertController(title: AppLoacalize.textString.selectSource, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: AppLoacalize.textString.camera, style: .default, handler: { (void) in
            self.chooseImage(with: .camera)
        }))
        alert.addAction(UIAlertAction(title: AppLoacalize.textString.photoLibrary, style: .default, handler: { (void) in
            self.chooseImage(with: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: AppLoacalize.textString.cancel, style: .cancel, handler: nil))
        alert.view.tintColor = .primaryColor
        imageCompletion = completion
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Show Image Picker
    
    private func chooseImage(with source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage {
                if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                    if let asset = result.firstObject?.value(forKey: "filename") as? String {
                        print(asset)
                        imageCompletion?(image, asset)
                    } else {
                        imageCompletion?(image, nil)
                    }
                } else {
                    imageCompletion?(image, nil)
                }
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension UIScrollView {
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
