//
//  EndType.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 13/06/22.
//

import Foundation
@_implementationOnly import Alamofire
@_implementationOnly import ObjectMapper

protocol EndPointType {
    // MARK: - Vars & Lets
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
}
