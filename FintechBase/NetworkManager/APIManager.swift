//
//  APIManager.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//

import Foundation
import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

struct Certificates {
    fileprivate static let sslCertificate: SecCertificate? = Certificates.certificate(filename:
                                                                                        (Bundle.main.infoDictionary?["SSL_CERTIFICATE"] as? String))
    
    private static func certificate(filename: String?) -> SecCertificate? {
        guard let filePath = Bundle.main.path(forResource: filename, ofType: "cer"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
              let certificate = SecCertificateCreateWithData(nil, data as CFData) else {
            return nil
        }
//        print("SSL Certificate Data Size :: \(data)")
//        print("SSL Certificate :: \(certificate)")
        return certificate
    }
}

final class APIManager {
    
    // MARK: - Accessors
    class func shared() -> APIManager {
        sharedApiManager
    }
    
    private var successFailurePopUpView = SuccessFailurePopUpView()
    
    // MARK: - Host To Evaluate
    private static var hostToEvaluate: String {
        guard let urlString = Bundle.main.infoDictionary?["API_BASE_URL_ENDPOINT"] as? String,
                let hostURL = URL(string: urlString), let host = hostURL.host else {
            return ""
        }
        return host
    }
    
    // MARK: - Evaluators
    private static var evaluators: [String: ServerTrustEvaluating] {
        guard let sslCertificate = Certificates.sslCertificate else {
            return [hostToEvaluate: DisabledTrustEvaluator()]
        }
        return [hostToEvaluate: PinnedCertificatesTrustEvaluator(certificates: [sslCertificate])]
    }
    
    // MARK: - Vars & Lets
    private let sessionManager: Session
    
    // MARK: - Vars & Lets
    private static var sharedApiManager: APIManager = {
        let manager = ServerTrustManager(evaluators: evaluators)
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.waitsForConnectivity = true
        /* With SSL Pinning */
        let apiManager = APIManager(sessionManager: Session(configuration: configuration, serverTrustManager: manager))
        /* Without SSL Pinning */
//        let apiManager = APIManager(sessionManager: Session())
        return apiManager
    }()
    
    // MARK: - Initialization
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    // MARK: Server Request
    func call<T: Mappable>(type: EndPointType, parameter: Parameters? = nil, withEncryption: Bool = true, completion: @escaping  (_ result: T?, _ error: String?, _ code: Int, _ headLessResponse: Any?) -> Void) {
        guard isInternetAvailable() else {
            return
        }
        showLoader()
//        print("====== headers ====== \n \(type.headers ?? [])")
        var params: Parameters = [:]
        if !withEncryption {
            params = parameter ?? [:]
        } else {
            if encryptionEnabled == "YES" {
                if parameter != nil {
                    params = EncryptionManager.shared.encryptParams(paramsToEncrypt: parameter ?? [:])
                }
            } else {
                params = parameter ?? [:]
            }
        }
//        print("====== parameter ====== \n \(parameter ?? [:])")
//        print("====== Final Url =====", type.url)
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers).validate().responseJSON { (response) in
            hideLoader()
            
            let code = response.response?.statusCode
//            print("====== code =====", code)
            if code == StatusCode.code.sessionTimeout {
                self.presentSuccessFailurePopUpView()
            } else {
                switch response.result {
                case .success(let json):
//                    print("====== Response Json ====== \n \(json)")
//                    print(response.response?.allHeaderFields as Any)
                    if withEncryption && encryptionEnabled == "YES" {
                        let encryptedResponse = Mapper<M2PEncryptionResponseModel>().map(JSONObject: json)
                        let results = EncryptionManager.shared.decryptParams(valueToDecrypt: encryptedResponse?.result ?? "", model: T.self)
//                        print("====== parameter ====== \n \(parameter ?? [:])")
//                        print("====== Final Url =====", type.url)
//                        print("====== Results Json ====== \n \(results)")
                        completion(results, nil, code ?? 0, nil)
                    } else {
                        let responseValue = Mapper<T>().map(JSONObject: json)
                        completion(responseValue, nil, code ?? 0, nil)
                    }
                case .failure(let error):
//                    print(error)
                    let isServerTrustEvaluationError =
                    error.asAFError?.isServerTrustEvaluationError ?? false
                    let errorMessage: String
                    if isServerTrustEvaluationError {
                        errorMessage = "Certificate Pinning Error"
                    } else {
                        errorMessage = error.localizedDescription
                    }
                    if errorMessage == "Unauthenticated." {
                        return
                    }
                    completion(nil, errorMessage, code ?? 0, nil)
                }
            }
        }
    }
    
    // MARK: Present SuccessFailure PopUp View
    private func presentSuccessFailurePopUpView() {
        if let topVC = UIApplication.getTopViewController() {
            self.successFailurePopUpView = SuccessFailurePopUpView(frame: CGRect(x: 0, y: 0, width: topVC.view.frame.width, height: topVC.view.frame.height))
            self.successFailurePopUpView.setUpData(data: SuccessFailurePopUpViewModel(title: AppLoacalize.textString.sessionExpired, description: AppLoacalize.textString.sessionExpireDescription, image: Image.imageString.sessionExpired, primaryButtonTitle: AppLoacalize.textString.login))
            self.successFailurePopUpView.onClickClose = { value in
                self.successFailurePopUpView.removeFromSuperview()
                topVC.navigationController?.popToRootViewController(animated: false)
            }
            topVC.view.addSubview(successFailurePopUpView)
        }
    }
}
