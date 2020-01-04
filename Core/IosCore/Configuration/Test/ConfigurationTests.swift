//
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import XCTest
@testable import Domain
@testable import IosCore

import Additions

class ConfigurationTests: XCTestCase {
    
    var config: Configuration!
    
    override func setUp() {
        super.setUp()
        config = Configuration.shared
        config.dispatcher = MockDispatcher()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_WhenStartingApp_ThenConfigsLoaded_AndFinishedSetup() {
        var capturedSetup = false
        config.loadConfiguration {
            capturedSetup = true
        }
    
        
        XCTAssertTrue(capturedSetup)
    }
    
    func test_WhenDeepLinking_ThenConfigsLoadedBeforeDeepLinking() {
        config.loadConfiguration {}
        
        let e = expectation(description: "test_WhenDeepLinking_ThenConfigsLoadedBeforeDeepLinking")
        var capturedDeepLink = false
        config.addToLoad {
            capturedDeepLink = true
            e.fulfill()
        }
        
        wait(for: [e], timeout: 1)
        XCTAssertTrue(capturedDeepLink)
    }
    
    func test_WhenDeepLinking_DeepLinkingInvalidBeforeConfig() {
        var capturedDeepLink = false
        config.addToLoad {
            capturedDeepLink = true
        }
        config.loadConfiguration {}
        
        XCTAssertFalse(capturedDeepLink)
    }
    
}

class MockFeatureFlagLoading: FeatureFlagLoader {
    var stubResult: FeatureFlags?
    override func load(completion: @escaping (FeatureFlags?) -> Void) {
        completion(stubResult)
    }
    
    init() {
        super.init(service: MockGenericDataService())
    }
}

class MockGenericDataService: GenericDataService {
    func getData<T>(fetchResult: @escaping (T?, ServiceError?) -> Void) {
        
    }
    
    func subscribe<T>(to updates: @escaping (T?, ServiceError?) -> Void) {
        
    }
}
