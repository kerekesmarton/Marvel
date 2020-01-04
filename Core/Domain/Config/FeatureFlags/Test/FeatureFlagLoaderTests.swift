//
//  DomainTests
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import XCTest
@testable import Domain

class FeatureFlagLoaderTests: XCTestCase {
    
    func test_GivenNoFlagValues_WhenAppLaunching_ThenSearchDisabled() {
        let mockedDataService = MockDataService<FeatureFlags, Swift.Void>()
        let useCase = FeatureFlagLoader(service: mockedDataService)
        var capturedFeatureFlag: FeatureFlags!
        useCase.load() { featureFlag in
            capturedFeatureFlag = featureFlag
        }
        XCTAssertNil(capturedFeatureFlag)
    }
    
}
