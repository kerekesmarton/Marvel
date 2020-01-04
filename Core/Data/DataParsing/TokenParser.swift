///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import JWTDecode

public class TokenParser: TokenParsing {
    public func parse(token: String) throws -> Token {
        let jwt = try decode(jwt: token)
        guard let token = Token(with: jwt) else {
            throw ServiceError.parsing("no token found")
        }
        return token
    }
    
    public init() {}
}

extension Token {
    init?(with jwt: JWT) {
        guard let body = Token.Body(with: jwt),
            let signature = jwt.signature else {
            return nil
        }
        
        self = Token(body: body, signature: signature, string: jwt.string)
    }
}

extension Token.Body {
    init?(with jwt: JWT) {
        
        guard let email = jwt.body["email"] as? String,
        let exp = jwt.body["exp"] as? Int,
        let userId = jwt.custom()?["userId"] ?? jwt.body["userId"] as? String,
        let tenantId = jwt.custom()?["primaryTenantId"] ?? jwt.body["tenantId"] as? String else {
            return nil
        }
        
        self = Token.Body(email: email, tenantId: tenantId, exp: exp, userId: userId)
    }
}

extension JWT {
    func custom() -> [String:String]? {
        return body["custom"] as? [String:String]
    }
}
