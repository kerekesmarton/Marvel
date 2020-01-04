//
//  Domain
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
#if TEST
@testable import Domain
#endif

public class MockDataService<Response, Request>: SpecialisedDataService {
    
    public init() {}
    public var stubResponse: Response?
    public var postDataCalled: Request?
    public var stubError: ServiceError?
    public var spyPayload:Any?
    
    public func getData<T>(fetchResult: @escaping (Result<T, ServiceError>) -> Void) {
        guard let response = stubResponse as? T else {
            fetchResult(.failure(stubError!))
            return
        }
        fetchResult(.success(response))
    }
    
    public var spyUrl: URL?
    public func getData<T>(from url: URL, completion: @escaping (Result<T, ServiceError>) -> Void) {
        spyUrl = url
        guard let response = stubResponse as? T else {
            completion(.failure(stubError!))
            return
        }
        completion(.success(response))
    }
    
    public func getData<T>(from url: URL, parameters: [String:String], completion: @escaping (Result<T, ServiceError>) -> Void) {
        spyUrl = url
        guard let response = stubResponse as? T else {
            completion(.failure(stubError!))
            return
        }
        completion(.success(response))
    }
    
    public var spyArrayParameters: [String]?
    public func getData<T>(parameters: [String], completion: @escaping (Result<T, ServiceError>) -> Void) {
        spyArrayParameters = parameters
        guard let response = stubResponse as? T else {
            completion(.failure(stubError!))
            return
        }
        completion(.success(response))
    }
    
    public var spyParameters: [String:String]?
    public func getData<T>(parameters: [String : String], completion: @escaping (Result<T, ServiceError>) -> Void) {
        spyParameters = parameters
        guard let response = stubResponse as? T else {
            completion(.failure(stubError!))
            return
        }
        completion(.success(response))
    }
    
    
    public func getData<T, U>(payload: U?, completion: @escaping (Result<T, ServiceError>) -> Void) {
        postDataCalled = payload as? Request
        spyPayload = payload
        guard let response = stubResponse as? T else {
            completion(.failure(stubError!))
            return
        }
        completion(.success(response))
    }
    
    public func getData<T, U>(parameters: [String : String], payload: U?, completion: @escaping (Result<T, ServiceError>) -> Void) {
        postDataCalled = payload as? Request
        spyParameters = parameters
        guard let response = stubResponse as? T else {
            completion(.failure(stubError!))
            return
        }
        completion(.success(response))
    }
    
    public func getData<T, U>(parameters: [String], payload: U?, completion: @escaping (Result<T, ServiceError>) -> Void) {
        postDataCalled = payload as? Request
        spyArrayParameters = parameters
        guard let response = stubResponse as? T else {
            completion(.failure(stubError!))
            return
        }
        completion(.success(response))
    }
    
    public var uploadCalled: Request?
    public var spyData: Data?    
    public func upload<T, U>(data: Data, parameters: [String : String], payload: U, completion: @escaping (Result<T, ServiceError>) -> Void) {
        spyData = data
        spyParameters = parameters
        uploadCalled = payload as? Request
        guard let response = stubResponse as? T else {
            completion(.failure(stubError!))
            return
        }
        completion(.success(response))
    }

    public func subscribeToCache<T>(changes: @escaping (Result<T, ServiceError>) -> Void) {
        guard let response = stubResponse as? T else {
            changes(.failure(stubError!))
            return
        }
        changes(.success(response))
    }
    
    var capturedChanges: ((Result<Request, ServiceError>) -> Void)?
    public func subscribeToCache<T>(with parameters: [String : String], changes: @escaping (Result<T, ServiceError>) -> Void) {
        capturedChanges = changes as? (Result<Request, ServiceError>) -> Void
    }
    
    var capturedUpdate: ((Result<Request, ServiceError>) -> Void)?
    public func fetchCache<T>(parameters: [String : String], update: @escaping (Result<T, ServiceError>) -> Void) {
        capturedUpdate = update as? (Result<Request, ServiceError>) -> Void
    }
    
    public func fetchCacheList<T>(parameters: [String : String], update: @escaping (Result<T, ServiceError>) -> Void) {
        capturedUpdate = update as? (Result<Request, ServiceError>) -> Void
    }
    
    public var saveCalled: Request?
    public func saveCache<T>(payload: T, parameters: [String : String], completion: @escaping (ServiceError?) -> Void) {
        saveCalled = payload as? Request
        completion(nil)
    }
    
    public var isCacheDeleted: Bool = false    
    public func deleteCache(completion: @escaping (ServiceError?) -> Void) {
        isCacheDeleted = true
        completion(nil)
    }
}
