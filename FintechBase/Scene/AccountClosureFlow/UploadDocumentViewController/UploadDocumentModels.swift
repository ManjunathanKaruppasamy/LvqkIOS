//
//  UploadDocumentModels.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 25/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum UploadDocument {
    // MARK: Use cases
    
    enum Something {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
}

struct DocumentDetailsField {
    var title: String?
    var placeholder: String = AppLoacalize.textString.selectProof
    var isFieldRequired: Bool = false
    var dropDownArray: [String]?
    var errorDescription: String?
    var selectedDocumentName: String?
    var isTextFieldHide: Bool = false
    var isTextFieldDepend: Bool = false
    var uploadDocumentTitle: String?
    var uploadDocumentDescription: String?
    var documentBase64Image: String?
    var documentImageTitle: String?
}
