//
//  DataTests
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import XCTest
@testable import Domain
@testable import Additions
@testable import Data

class NetworkDataServiceTests: XCTestCase {
    
    var entity = StubEntity(field: "test")
    var mockedRequestBuilder = MockRequestBuilder()
    var mockedSession: MockSession!
    
    fileprivate func givenStandardService(_ method: HTTPMethod = .get) -> SpecialisedDataService {
        mockedSession = MockSession()
        mockedSession.stubData = Data()
        let mockedParser = MockDataParser<StubEntity>()
        mockedParser.stubEntity = entity
        mockedRequestBuilder.stubRequest = URLRequest(url: URL(string: "a@a.com")!)
        mockedRequestBuilder.method = method
        let service = NetworkDataService(requestBuilder: mockedRequestBuilder, dataParser: mockedParser, dataEncoder: nil, session: mockedSession)
        service.dispatcher = MockDispatcher()
        return service
    }
    
    fileprivate func givenService(with mockedRequestBuilder: MockRequestBuilder, _ mockedParser: MockDataParser<StubEntity>, _ mockedSession: MockSession, _ persistence: MockDataPersisting? = nil) -> SpecialisedDataService {
        let service = NetworkDataService(requestBuilder: mockedRequestBuilder, dataParser: mockedParser, dataEncoder: nil, session: mockedSession, dataPersistence: persistence)
        service.dispatcher = MockDispatcher()
        return service
    }
    
    func test_GivenNoData_WhenGettingData_ThenErrorReturned() {
        let mockedSession = MockSession()
        mockedSession.stubStatus = 400
        let mockedParser = MockDataParser<StubEntity>()
        let mockedRequestBuilder = MockRequestBuilder()
        mockedRequestBuilder.stubRequest = URLRequest(url: URL(string: "a@a.com")!)
        let service = givenService(with: mockedRequestBuilder, mockedParser, mockedSession)
        
        var capturedError: ServiceError?
        var capturedEntity: StubEntity?
        service.getData(from: URL(string: "a@a.com")!) { (entity: StubEntity?, error) in
            capturedEntity = entity
            capturedError = error
        }
        
        XCTAssertEqual(mockedSession.spyRequest?.url?.absoluteString, mockedRequestBuilder.request.url?.absoluteString)
        guard case .client = capturedError! else {
            XCTFail()
            return
        }
        XCTAssertNil(capturedEntity)
    }
    
    func test_GivenParsingError_WhenGettingData_ThenErrorReturned() {
        let mockedSession = MockSession()
        let stubURL: URL = URL(string: "a@a.com")!
        let error = ErrorResponse(message: "message", error: "error", status: 404, path: nil)
        mockedSession.stubData = try? JSONEncoder().encode(error)
        let mockedParser = MockDataParser<StubEntity>()
        let urlResponse: HTTPURLResponse = HTTPURLResponse(url: stubURL, mimeType: nil, expectedContentLength: 100, textEncodingName: nil)
        mockedParser.stubError = ServiceError.server(urlResponse, nil)
        let mockedRequestBuilder = MockRequestBuilder()
        mockedRequestBuilder.stubRequest = URLRequest(url: URL(string: "a@a.com")!)
        let service = givenService(with: mockedRequestBuilder, mockedParser, mockedSession)
        
        var capturedError: ServiceError?
        var capturedEntity: StubEntity?
        
        service.getData(from: stubURL) { (entity: StubEntity?, error) in
            capturedEntity = entity
            capturedError = error
        }
        
        XCTAssertEqual(mockedSession.spyRequest?.url?.absoluteString, mockedRequestBuilder.request.url?.absoluteString)
        guard let capturedServerError = capturedError, case ServiceError.server(_, _) = capturedServerError else {
            XCTFail()
            return
        }
        XCTAssertNotNil(mockedParser.spyData)        
        XCTAssertNil(capturedEntity)
    }
    
    func test_GivenGettingData_SuccessWithDifferentData_ThenErrorReturned() {
        let mockedSession = MockSession()
        mockedSession.stubData = "error".data(using: .utf8)
        let mockedParser = MockDataParser<StubEntity>()
        let mockedRequestBuilder = MockRequestBuilder()
        mockedRequestBuilder.stubRequest = URLRequest(url: URL(string: "a@a.com")!)
        let service = givenService(with: mockedRequestBuilder, mockedParser, mockedSession)
        
        var capturedError: ServiceError?
        var capturedEntity: StubEntity?
        service.getData(from: URL(string: "a@a.com")!) { (entity: StubEntity?, error) in
            capturedEntity = entity
            capturedError = error
        }        
        XCTAssertEqual(mockedSession.spyRequest?.url?.absoluteString, mockedRequestBuilder.request.url?.absoluteString)
        XCTAssertNil(capturedError)
        XCTAssertNil(capturedEntity)
    }
    
    func test_GivenGettingData_WhenWrongData_ThenErrorReturned() {
        let url: URL = URL(string: "a@a.com")!
        let mockedSession = MockSession()
        mockedSession.stubStatus = 400
        let mockedParser = MockDataParser<StubEntity>()
        let mockedRequestBuilder = MockRequestBuilder()
        
        mockedRequestBuilder.stubRequest = URLRequest(url: url)
        let service = givenService(with: mockedRequestBuilder, mockedParser, mockedSession)
        
        var capturedError: ServiceError?
        var capturedEntity: StubEntity?
        service.getData(from: URL(string: "a@a.com")!) { (entity: StubEntity?, error) in
            capturedEntity = entity
            capturedError = error
        }
        
        XCTAssertEqual(mockedSession.spyRequest?.url?.absoluteString, mockedRequestBuilder.request.url?.absoluteString)
        guard case .client = capturedError! else {
            XCTFail()
            return
        }
        XCTAssertNil(capturedEntity)
    }
    
    func test_GivenGettingData_WhenSuccesful_ThenResultReturned() {
        let mockedSession = MockSession()
        mockedSession.stubData = Data()
        let mockedParser = MockDataParser<StubEntity>()
        let entity = StubEntity(field: "test")
        mockedParser.stubEntity = entity
        let mockedRequestBuilder = MockRequestBuilder()
        mockedRequestBuilder.stubRequest = URLRequest(url: URL(string: "a@a.com")!)
        let service = givenService(with: mockedRequestBuilder, mockedParser, mockedSession)
        
    
        var capturedEntity: StubEntity?
        var capturedError: ServiceError?
        service.getData(from: URL(string: "a@a.com")!) { (entity: StubEntity?, error) in
            capturedEntity = entity
            capturedError = error
        }
        
        XCTAssertEqual(mockedSession.spyRequest?.url?.absoluteString, mockedRequestBuilder.request.url?.absoluteString)
        XCTAssertEqual(capturedEntity?.field, entity.field)
        XCTAssertNil(capturedError)
    }
    
    func test_GivenGettingData_AndPersistenceSet_WhenSuccesful_ThenResultReturned() {
        let mockedSession = MockSession()
        mockedSession.stubData = Data()
        let mockedParser = MockDataParser<StubEntity>()
        
        mockedParser.stubEntity = entity
        let mockedRequestBuilder = MockRequestBuilder()
        mockedRequestBuilder.stubRequest = URLRequest(url: URL(string: "a@a.com")!)
        let mockedPersistence: MockDataPersisting = MockDataPersisting()
        mockedPersistence.stubItems = entity
        let service = givenService(with: mockedRequestBuilder, mockedParser, mockedSession, mockedPersistence)
        
        
        var capturedEntity: StubEntity?
        var capturedError: ServiceError?
        service.getData(from: URL(string: "a@a.com")!) { (entity: StubEntity?, error) in
            capturedEntity = entity
            capturedError = error
        }
        
        XCTAssertEqual(mockedSession.spyRequest?.url?.absoluteString, mockedRequestBuilder.request.url?.absoluteString)
        XCTAssertEqual(capturedEntity?.field, entity.field)
        XCTAssertNil(capturedError)
    }
    
    func test_givenPatchWithParameters_ThenParametersProcessed() {
        let method: HTTPMethod = .patch
        let service = givenStandardService(method)
        let params = ["postId": "1", "commentId": "1"]
        
        service.getData(parameters: params, payload: entity) { (entity: StubEntity?, error) in }
        
        XCTAssertEqual(mockedRequestBuilder.spyParams, params)
        
        XCTAssertEqual(mockedSession.spyRequest!.httpMethod!, method.rawValue)
    }
    
    func test_givenDeleteWithParameters_ThenParametersProcessed() {
        let method: HTTPMethod = .delete
        let service = givenStandardService(method)
        let params = ["postId": "1", "commentId": "1"]
        
        service.getData(parameters: params) { (entity: StubEntity?, error) in }
        
        XCTAssertEqual(mockedRequestBuilder.spyParams, params)
        XCTAssertEqual(mockedSession.spyRequest!.httpMethod, method.rawValue)
    }
    
    func test_givenPostWithParameters_ThenParametersProcessed() {
        let method: HTTPMethod = .post
        let service = givenStandardService(method)
        let params = ["postId": "1", "commentId": "1"]
        
        service.getData(parameters: params, payload: entity) { (entity: StubEntity?, error) in }
        
        XCTAssertEqual(mockedRequestBuilder.spyParams, params)
        XCTAssertEqual(mockedSession.spyRequest!.httpMethod, method.rawValue)
    }
    
    func test_givenPutWithParameters_ThenParametersProcessed() {
        let method: HTTPMethod = .put
        let service = givenStandardService(method)
        let params = ["postId": "1", "commentId": "1"]
        
        service.getData(parameters: params, payload: entity) { (entity: StubEntity?, error) in }
        
        XCTAssertEqual(mockedRequestBuilder.spyParams, params)
        XCTAssertEqual(mockedSession.spyRequest!.httpMethod, method.rawValue)
    }
}

class MockSession: Sessionable {
    var spyRequest: URLRequest?
    var stubData: Data?
    var stubStatus: Int = 200
    var stubError: Error?
    var stubResponse: URLResponse? {
        if let url = spyRequest?.url {
            return HTTPURLResponse(url: url, statusCode: stubStatus, httpVersion: nil, headerFields: [:])
        }
        return nil
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        spyRequest = request        
        completionHandler(stubData, stubResponse, stubError)
        return StubDataTask()
    }
    
    func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        spyRequest = request
        completionHandler(stubData, stubResponse, stubError)
        return StubUploadTask()
    }
}

class StubDataTask: URLSessionDataTask {
    override func resume() {}
}

class StubUploadTask: URLSessionUploadTask {
    override func resume() {}
}
