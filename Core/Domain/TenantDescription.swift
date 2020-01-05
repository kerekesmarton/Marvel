///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public class TenantDescription {
    public let publicKey: String
    public let privateKey: String
    
    init(defaults: DefaultSettings, environment: Environment) {
        publicKey = defaults.string(forKey: "publicKey")!
        privateKey = defaults.string(forKey: "privateKey")!
    }
    
    init(publicKey: String, privateKey: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
}
