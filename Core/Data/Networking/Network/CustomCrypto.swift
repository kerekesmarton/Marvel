//
//  MD5.swift
//  Additions
//
//  Created by Marton Kerekes on 05/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class CustomCrypto: Encryptable {
    
    func md5Data(from string: String) -> Data {
        return md5(from: string)
    }
    
    func md5Hex(from string: String) -> String {
        return md5(from: string).map { String(format: "%02hhx", $0) }.joined()
    }
    
    func md5Base64(from string: String) -> String {
        return md5(from: string).base64EncodedString()
    }
    
    func md5(from string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
}

