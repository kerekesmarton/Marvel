//
//  DataTests
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import XCTest
@testable import Domain
@testable import Data

class BundleLoaderDataServiceTests: XCTestCase {
    
    fileprivate func givenDataService(_ mockDataParser: MockDataParser<StubEntity>, stubPath: String? = nil) -> TestableBundleLoaderDataService {
        let file = MockBundledFile(stubPath: stubPath)
        return TestableBundleLoaderDataService(file: file, parser: mockDataParser)
    }
    
    func testGivenFileNotFound_WhenLoadingData_ThenFoundError() {
        let mockDataParser = MockDataParser<StubEntity>()
        let bundleLoaderDataService = givenDataService(mockDataParser)
        
        var capturedEntity: StubEntity?
        var capturedError: ServiceError?
        bundleLoaderDataService.getData { (result: Result<StubEntity, ServiceError>) in
            do {
                capturedEntity = try result.get()
            } catch {
                capturedError = ServiceError(from: error)
            }
        }
        
        XCTAssertNil(capturedEntity?.field)
        
        guard case .parsing(let capturedMessage)? = capturedError else {
            XCTFail()
            return
        }
        XCTAssertEqual(capturedMessage, "File not found")
    }
    
    func testGivenDataInvalid_WhenLoadingData_ThenFoundError() {
        let mockDataParser = MockDataParser<StubEntity>()
        let bundleLoaderDataService = givenDataService(mockDataParser, stubPath: "path")
        
        var capturedEntity: StubEntity?
        var capturedError: ServiceError?
        bundleLoaderDataService.getData { (result: Result<StubEntity, ServiceError>) in
            do {
                capturedEntity = try result.get()
            } catch {
                capturedError = ServiceError(from: error)
            }
        }
        
        XCTAssertNil(capturedEntity?.field)
        
        guard case .parsing(let capturedMessage)? = capturedError else {
            XCTFail()
            return
        }
        XCTAssertEqual(capturedMessage, "Failed to load")
    }
    
    func testGivenDataValid_WhenLoadingData_ThenReturnsData() {
        let mockDataParser = MockDataParser<StubEntity>()
        let bundleLoaderDataService = givenDataService(mockDataParser, stubPath: "path")
        mockDataParser.stubEntity = StubEntity(field: "field")
        bundleLoaderDataService.stubData = Data()
        
        var capturedEntity: StubEntity?
        var capturedError: ServiceError?
        bundleLoaderDataService.getData { (result: Result<StubEntity, ServiceError>) in
            do {
                capturedEntity = try result.get()
            } catch {
                capturedError = ServiceError(from: error)
            }
        }
        
        XCTAssertNil(capturedError)
        
        XCTAssertEqual(capturedEntity?.field, "field")
    }
}

class TestableBundleLoaderDataService: BundleLoaderDataService<MockDataParser<StubEntity>> {
    var stubData: Data?
    override func data(from file: String) -> NSData? {
        return (stubData as NSData?)
    }
}

struct MockBundledFile: PathCalculator {
    let stubPath: String?
    var path: String? {
        return stubPath
    }
}
