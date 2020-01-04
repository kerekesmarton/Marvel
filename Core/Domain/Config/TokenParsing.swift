///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public struct Token: Equatable {
    public struct Body: Equatable {
        public var email: String
        public var tenantId: String
        public var exp: Int
        public var userId: String
        
        public init(email: String, tenantId: String, exp: Int, userId: String) {
            self.email = email
            self.tenantId = tenantId
            self.exp = exp
            self.userId = userId
        }
        
    }
    
    public var body: Body
    public var signature: String?
    public var string: String
    
    public init(body: Body, signature: String?, string: String) {
        self.body = body
        self.signature = signature
        self.string = string
    }
}

public protocol TokenParsing {
    func parse(token: String) throws -> Token
}
