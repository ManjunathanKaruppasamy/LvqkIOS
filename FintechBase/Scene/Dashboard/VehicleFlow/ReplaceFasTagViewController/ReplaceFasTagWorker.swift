//
//  ReplaceFasTagWorker.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 16/03/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

class ReplaceFasTagWorker {
    // MARK: Fetch replace tag list
    func getTagApi(params: Parameters?, completion: @escaping  (_ results: ReplaceFastTags?,
                                                                          _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.getTags, parameter: params) { (result: ReplaceFastTags?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
    
    // MARK: Replace fast tag
    func applyReplaceFastTagApi(params: Parameters?, completion: @escaping  (_ results: FastTagReplaceCard?,
                                                                        _ code: Int?) -> Void) {
        APIManager.shared().call(type: EndpointItem.replaceFastTag, parameter: params) { (result: FastTagReplaceCard?, error, code, headLessResponse) in
            if let result = result, code == 200 {
                completion(result, code)
            } else {
                completion(nil, code)
            }
        }
    }
}
