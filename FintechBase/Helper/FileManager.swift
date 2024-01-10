//
//  FileManager.swift
//  FintechBase
//
//  Created by Balaji  on 19/04/23.
//

import Foundation
import WebKit

final class FileLocationManager {
    
    static let shared = FileLocationManager()
    
    init() {
    }
    
    func saveData(pdfView: UIView?, isReceipt: Bool) {
        // create print formatter object
        guard let printFormatter = (pdfView?.viewPrintFormatter()) else {
            return
        }
        // create renderer which renders the print formatter's content on pages
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        // Specify page sizes
        let pageSize = CGSize(width: 595.2, height: 841.8) // set desired sizes
        
        // Page margines
        let margin = CGFloat(20.0)
        
        // Set page sizes and margins to the renderer
        renderer.setValue(NSValue(cgRect: CGRect(x: margin, y: margin, width: pageSize.width, height: pageSize.height - margin * 2.0)), forKey: "paperRect")
        renderer.setValue(NSValue(cgRect: CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)), forKey: "printableRect")
        
        // Create data object to store pdf data
        let pdfData = NSMutableData()
        // Start a pdf graphics context. This makes it the current drawing context and every drawing command after is captured and turned to pdf data
        if isReceipt {
            let imageRect = CGRect(x: 0, y: 0, width: pdfView?.frame.width ?? 200, height: pdfView?.frame.height ?? 600)
            UIGraphicsBeginPDFContextToData(pdfData, imageRect, nil)
        } else {
            UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        }
        
        // Loop through number of pages the renderer says it has and on each iteration it starts a new pdf page
        for page in 0..<renderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            // draw content of the page
            renderer.drawPage(at: page, in: UIGraphicsGetPDFContextBounds())
        }
        // Close pdf graphics context
        UIGraphicsEndPDFContext()
        
        let fileManager = FileManager.default
        let documentsFolder = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        guard let folderURL = documentsFolder?.appendingPathComponent(PARENTFOLDERNAME)
        else {
            return
        }
        let folderExists = try? folderURL.checkResourceIsReachable()
        do {
            if folderExists != true {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: false)
            }
            let currentTimeStamp = Date().timeIntervalSince1970.description
            let foldername = "\(isReceipt ? PDFRECEIPTFILENAME : PDFFITMENTCERTIFICATE)_\(currentTimeStamp).pdf"
            let fileURL = folderURL.appendingPathComponent(foldername)
            pdfData.write(to: fileURL, atomically: true)
//            print("fileURL.absoluteString:\(fileURL.absoluteString)")
            showSuccessToastMessage(message: isReceipt ? AppLoacalize.textString.downloadSuccess : AppLoacalize.textString.fitmentSuccess, messageColor: UIColor.white, bgColour: UIColor.greenTextColor, position: .betweenBottomAndCenter)
        } catch {
//            print(error)
        }
    }
}
