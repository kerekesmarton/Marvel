//
//  Data
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain

public class MockKeychainWrapper: KeychainLoading, SessionCleaning {
    public init() {}
    
    public var id: String? = "28"
    public var token: String? {
        if let value = ProcessInfo().environment["userLoggedIn"], value == "false" {
            return nil
        }
        return "token"
    }
    
    public func saveToken(_ value: String) {
        
    }
    
    public var hasSession: Bool {
        if let value = ProcessInfo().environment["userLoggedIn"], value == "false" {
            return false
        }
        return true
    }
    
    public func deleteSession() {
        
    }
    
    public func deleteUserId() {
        
    }
}
