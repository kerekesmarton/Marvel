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
 
    #warning("remove this")
    static var standard: TenantDescription {
        return TenantDescription(publicKey: "4b3d281d06587a0d8d0c8d0b3c3b2628", privateKey: "d9388877b0f4471a0c947834de44afd46fc2c601")
    }
}
