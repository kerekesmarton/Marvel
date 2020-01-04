//
//  Data
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import KeychainSwift

public class KeyChainWrapper {
    struct Keys {
        static let tokenKey = "auth_token"
        static let prefix = "ctapp_"
        static let anonymousDistinctId = "anonymousDistinctId"
        static let userId = "userId"
    }
    public init (){}
    lazy var keychain: KeychainSwift? = {
        if NSClassFromString("XCTest") == nil {
            return KeychainSwift(keyPrefix: Keys.prefix)
        }
        return nil
    }()
}

extension KeyChainWrapper: SessionCleaning {
    public func deleteSession() {
        keychain?.delete(Keys.tokenKey)
    }

    public func deleteUserId() {
        keychain?.delete(Keys.userId)
    }
    
    public var hasSession: Bool {
        guard let token = keychain?.get(Keys.tokenKey) else { return false }
        return token.count > 0 ? true : false
    }
}

extension KeyChainWrapper: KeychainLoading {
    public var token: String? {
        return keychain?.get(Keys.tokenKey)
    }
    
    public func saveToken(_ value: String) {
        keychain?.set(value, forKey: Keys.tokenKey)
    }
    
    public var id: String? {
        get {
            return keychain?.get(Keys.userId)
        }
        set {
            guard let newValue = newValue else {
                keychain?.delete(Keys.userId)
                return
            }
            keychain?.set(newValue, forKey: Keys.userId)
        }
    }
}
