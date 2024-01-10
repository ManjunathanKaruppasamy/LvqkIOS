//
//  InvokeCardManagementSdk.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 05/04/23.
//

import Foundation
import UIKit
import PCIWidget

class InvokeCardManagementSdk: NSObject {
    
    var publicLocalString: String?
    internal var privateKeyString: String?
    internal var publicServerString: String?
    internal var dynamicURLKey: String?
    internal var presentViewController = UIViewController()
    private var successFailurePopUpView = SuccessFailurePopUpView()
    
    // MARK: InvokeSDK
    func invokeSDK(data: SDKModels, trackIssueHandler: @escaping (String) -> Void) {
        self.presentViewController = data.presentViewController
        M2PCD.shared.m2pSDKEnvironment = isCardProduction ? .PROD : .UAT
        M2PCD.shared.flowType = data.flowType
        let dob = data.dob.replacingOccurrences(of: "/", with: "")
        if let cardDetails = data.getCardResultArray {
            M2PCD.shared.m2pCDParams = [
                "token": "jzo/kSRYYiQ/5JcHctndNSsVQsODwiAUbFstKiz/DEMx3WkA6OytnCyB4/XXonZw",
                "kitNo": cardDetails.kitNumber ?? "",
                "entityId": ENTITYID ,
                "business": TENANT.uppercased(),
                "iFrame": false,
                "dob": dob,
                "endPoint": true,
                "transactionID": data.transactionID
            ]
            /* Dispute track issue callback */
            M2PCD.shared.onTrackID = { id in
                trackIssueHandler(id)
            }
            
            /* SDK close action */
            M2PCD.shared.onSDKClose = { closeMessage in
                if closeMessage == M2PSDKDismissType.status.permanentBlock {
                    self.presentSuccessFailurePopUpView()
                } else if closeMessage == M2PSDKDismissType.status.noInternet {
                    guard isInternetAvailable() else {
                        return
                    }
                }
            }
            
            M2PCD.shared.onTransactionDetailImage = { imageData in
                self.createPDFDataFromImage(image: imageData)
            }
        
            /* Basic reuired details*/
            M2PCD.shared.m2pTenantName = CORPORATE == "" ? TENANT.uppercased() : CORPORATE // Tenant from constant
            M2PCD.shared.m2pUserMobileNo = userMobileNumber
            M2PCD.shared.m2pUserPhoneCountryCode = AppLoacalize.textString.countryCode
            M2PCD.shared.m2pUserNationalID = ""
            M2PCD.shared.m2pEnableBioMetric = false
            
            /* Basic configurations */
            M2PCD.shared.language = "en"
            M2PCD.shared.themeColorHexString = "#422A78" // To change theme
            M2PCD.shared.m2pCardBgImage = UIImage(named: Image.imageString.managecardBg) // Full card image
            M2PCD.shared.m2pCardLogo = UIImage(named: "fasttag") // Logo like master , visa
            M2PCD.shared.supportContactNumber = "+919790814670" // Along with Country code
            M2PCD.shared.brandLogoImage = UIImage(named: "logo") // Brand Logo
            self.initialKeyHandle()
        }
    }
    
    private func createPDFDataFromImage(image: UIImage) {
        let imgView = UIImageView.init(image: image)
        FileLocationManager.shared.saveData(pdfView: imgView, isReceipt: true)
    }
}

extension InvokeCardManagementSdk {
    private func presentSuccessFailurePopUpView() {
        if let topVC = UIApplication.getTopViewController() {
            self.successFailurePopUpView = SuccessFailurePopUpView(frame: CGRect(x: 0, y: 0, width: topVC.view.frame.width, height: topVC.view.frame.height ))
            successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.cardBlocked, description: AppLoacalize.textString.cardBlockDescription, image: Image.imageString.cardBlocked, primaryButtonTitle: AppLoacalize.textString.okText, isCloseButton: false))
            self.successFailurePopUpView.onClickClose = { value in
                self.successFailurePopUpView.removeFromSuperview()
            }
            topVC.view.addSubview(successFailurePopUpView)
        }
    }
}

// MARK: Invoke SDK Params
struct SDKModels {
    var getCardResultArray: GetCardResultArray?
//    var getMultiCardResultArray: MultiCardArray?
    var dob: String
    var flowType: M2PFlowType
    var presentViewController: UIViewController
    var transactionID: String = ""
}
