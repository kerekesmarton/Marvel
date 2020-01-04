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
        return stubRequest!
    }
    
    var spyParams: [String: String]?
    func preprocess(parameters: inout [String: String]) -> [String: String] {
        spyParams = parameters
        return parameters
    }
    
    init() {
        super.init(config: MockSettingsConfigurable(defaults: UserDefaults(suiteName: nil)!))
    }
}
