//
//  Data
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
@testable import Data
@testable import Domain

class MockRequestBuilder: BaseRequestBuilder, RequestBuilding {
  
    var stubRequest: URLRequest?
    var request: URLRequest {
        return stubRequest ?? URLRequest(url: stubURL)
    }
    
    var spyParams: [String: String]?
    func preprocess(parameters: inout [String: String]) -> [String: String] {
        spyParams = parameters
        return parameters
    }
    
    init() {
        super.init(store: MockUserProfileStore(defaults: MockDefaultSettings()), config: MockSettingsConfigurable(defaults: UserDefaults(suiteName: nil)!), crypto: MockEncryptable(), uniqueStringProviding: UniqueStringProvider())
    }
    
    var stubURL = URL(string: "some.url")!
    func createUrl() throws -> URL {
        return stubURL
    }
}

final class MockEncryptable: Encryptable{
    
    var stubData = Data()
    func md5Data(from string: String) -> Data {
        return Data()
    }
    
    var stubHex = "8b1a9953c4611296a827abf8c47804d7"
    func md5Hex(from string: String) -> String {
        return stubHex
    }
    
    var stubBase64 = "ixqZU8RhEpaoJ6v4xHgE1w=="
    func md5Base64(from string: String) -> String {
        return stubBase64
    }
    
    
}
