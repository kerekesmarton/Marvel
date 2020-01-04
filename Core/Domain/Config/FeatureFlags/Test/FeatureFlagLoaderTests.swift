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
        mockedDataService.stubResponse = FeatureFlags(uploadVideo: false, searchTabs: false, mention: false)
        let useCase = FeatureFlagLoader(service: mockedDataService)
        var capturedFeatureFlag: FeatureFlags!
        useCase.load() { featureFlag in
            capturedFeatureFlag = featureFlag
        }
        XCTAssertFalse(capturedFeatureFlag.searchTabs)
    }
    
}
