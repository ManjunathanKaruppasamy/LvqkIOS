//
//  EncryptionManager.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 20/06/22.
//

import Foundation
@_implementationOnly import ObjectMapper
@_implementationOnly import Alamofire
import CryptoKit
import CryptoSwift
import SwCrypt

final class EncryptionManager {
    
    // swiftlint:disable missing_docs force_try
    public init () {}
    
    static let shared = EncryptionManager()
//    let deviceID = UIDevice.current.identifierForVendor?.uuidString.filter { $0 != "-" }
    
    func encryptParams(paramsToEncrypt: Parameters?) -> Parameters {
        let valueToEncrypt = self.getEncodedPayload(encryptParamsdict: paramsToEncrypt)
        let sharedSecret = try? CC.EC.computeSharedSecret(clientPrivateKeyString.hexadecimal ?? Data(), publicKey: serverPublickey.hexadecimal ?? Data())
//        print("sharedSecret-->>InAPP", sharedSecret?.toHexString() ?? "")
        let randomIVBytes = CommonFunctions().generateRandomBytes()
        if let sharedSecret {
            let encryptResult = valueToEncrypt.AESEncrypt(AESKEY: (sharedSecret.withUnsafeBytes(Array.init)), IVKEY: randomIVBytes)
            let encryptedParams: Parameters = ["data": encryptResult]
            return encryptedParams
        }
//        print("Encrypted Parameters ---->>", encryptedParams)
        return [:]
    }
    
    func decryptParams<T: Mappable>(valueToDecrypt: String?, model: T.Type) -> T? {
        let sharedSecret = try! CC.EC.computeSharedSecret(clientPrivateKeyString.hexadecimal ?? Data(), publicKey: serverPublickey.hexadecimal ?? Data())
        let encryptedArray = Data(base64Encoded: valueToDecrypt ?? "", options: .ignoreUnknownCharacters)
        let totalResponse = encryptedArray?.bytes
//        print(totalResponse)
        let getRandomIV = [UInt8]((totalResponse?[0...15]) ?? ArraySlice<UInt8>() )
        let encryptedBytes = [UInt8]((totalResponse?[16...]) ?? ArraySlice<UInt8>())
        let decryptValue = encryptedBytes.toBase64()
        let decryptResult = decryptValue.AESDecrypt(aesKey: sharedSecret.withUnsafeBytes(Array.init), IVKEY: getRandomIV)
        
        // swiftlint:disable force_cast
        return decryptResult.convertToDictionary(type: model)
    }
    
    private func getEncodedPayload(encryptParamsdict: [String: Any]?) -> String {
        do {
            let dictData: Data = try JSONSerialization.data(withJSONObject: encryptParamsdict ?? "",
                                                             options: .fragmentsAllowed)
            return String(data: dictData, encoding: .utf8) ?? ""
        } catch {
//            print(error)
        }
        return  ""
    }
}

extension String {
    /*encryption Algo*/
    
    func AESEncrypt(AESKEY: [UInt8], IVKEY: [UInt8]) -> String {
        var result = ""
        do {
            let aes = try! AES(key: AESKEY, blockMode: GCM(iv: IVKEY, mode: .combined) as BlockMode, padding: .noPadding)
            let encrypted = try aes.encrypt(Array(self.utf8))
//            print("Encrypted Bytes ====", encrypted)
            let combineBytes: [UInt8] = IVKEY + encrypted
            result = combineBytes.toBase64()
        } catch {
//            print("Error: \(error)")
        }
        return result
    }
    
    /*decryption Algo*/
    func AESDecrypt(aesKey: [UInt8], IVKEY: [UInt8]) -> String {
        var result = ""
        do {
            let encrypted = self
            let aes = try AES(key: aesKey, blockMode: GCM(iv: IVKEY, mode: .combined) as BlockMode, padding: .noPadding)
            let decrypted = try aes.decrypt(Array(base64: encrypted))
            result = String(data: Data(decrypted), encoding: .utf8) ?? ""
        } catch {
//            print("Error: \(error)")
        }
        return result
    }
    
    /*Convert Json to Dict*/
    func convertToDictionary<T: Mappable>(type: T.Type) -> T? {
        if let data = self.data(using: .utf8) {
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let result = Mapper<T>().map(JSONObject: jsonResponse)
                return result
            } catch {
                return nil
            }
        }
        return nil
    }
    
    /*trim Empty String*/
    var trim: String {
        self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /*encryption Algo*/
    func aes_EncryptHexaString(aesKey: [UInt8]) -> String {
        var result = ""
        do {
            let ivValue: [UInt8] = Array(repeating: UInt8(0), count: 16)
            let aes = try AES(key: aesKey, blockMode: CBC(iv: ivValue) as BlockMode, padding: .pkcs7)
            let encrypted = try aes.encrypt(Array(self.utf8))
            result = encrypted.toHexString()
        } catch {
//            print("Error: \(error)")
        }
        return result
    }
    
    func twoDecimalFormatting() -> String {
        let floatValue = Float(self)
        let formatString = String(format: "%.2f", floatValue ?? 0.00)
        return formatString
    }
}

struct M2PEncryptionResponseModel: Mappable {
    var status: String?
    var result: String?
    
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        status <- map["status"]
        result <- map["result"]
    }
}
