//
//  DataTests
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
#if TEST
@testable import Data
#endif

struct StubEntity {
    let field: String
}

struct StubDecodable: Decodable {
    let field: String
}

class MockDataParser<T>: DataParsing {
    typealias M = StubDecodable
    
    var persisting: Bool = false
    var spyData: Data?
    var stubEntity: T?
    var stubError: Error?
    
    func decode<T>(from data: Data, source: URL?) throws -> T {
        spyData = data
        guard let stubEntity = stubEntity else {
            if let stubError = stubError {
                throw stubError
            }
            throw ServiceError.unknown
        }
        return stubEntity as! T
    }
}
