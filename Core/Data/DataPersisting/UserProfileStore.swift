///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Domain

public class UserProfileStore: UserProfileStoring {
    
    public init() {}
    
    private let _publicKeyHandle = "user.publicKey"
    public var publicKey: String? {
        get {
            guard let token = UserDefaults.standard.string(forKey: _publicKeyHandle) else {
                return nil
            }
            return token
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: _publicKeyHandle)
                return
            }
            UserDefaults.standard.set(newValue, forKey: _publicKeyHandle)
        }
    }
    
    private let _privateKeyHandle = "user.privateKey"
    public var privateKey: String? {
        get {
            guard let token = UserDefaults.standard.string(forKey: _privateKeyHandle) else {
                return nil
            }
            return token
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: _privateKeyHandle)
                return
            }
            UserDefaults.standard.set(newValue, forKey: _privateKeyHandle)
        }
    }
    
}
