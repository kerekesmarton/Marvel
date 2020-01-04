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
    
    public func getData<T>(fetchResult: @escaping (T?, ServiceError?) -> Void) {
        guard let response = stubResponse as? T else {
            fetchResult(nil, stubError)
            return
        }
        fetchResult(response, stubError)
    }
    
    public var spyUrl: URL?
    public func getData<T>(from url: URL, completion: @escaping (T?, ServiceError?) -> Void) {
        spyUrl = url
        guard let response = stubResponse as? T else {
            completion(nil, stubError)
            return
        }
        completion(response, stubError)
    }
    
    public func getData<T>(from url: URL, parameters: [String:String], completion: @escaping (T?, ServiceError?) -> Void) {
        spyUrl = url
        guard let response = stubResponse as? T else {
            completion(nil, stubError)
            return
        }
        completion(response, stubError)
    }
    
    public var spyArrayParameters: [String]?
    public func getData<T>(parameters: [String], completion: @escaping (T?, ServiceError?) -> Void) {
        spyArrayParameters = parameters
        completion((stubResponse as? T), stubError)
    }
    
    public var spyParameters: [String:String]?
    public func getData<T>(parameters: [String : String], completion: @escaping (T?, ServiceError?) -> Void) {
        spyParameters = parameters
        guard let response = stubResponse as? T else {
            completion(nil, stubError)
            return
        }
        completion(response, stubError)
    }
    
    
    public func getData<T, U>(payload: U?, completion: @escaping (T?, ServiceError?) -> Void) {
        postDataCalled = payload as? Request
        spyPayload = payload
        completion((stubResponse as? T), stubError)
    }
    
    public func getData<T, U>(parameters: [String : String], payload: U?, completion: @escaping (T?, ServiceError?) -> Void) {
        postDataCalled = payload as? Request
        spyParameters = parameters
        completion((stubResponse as? T), stubError)
    }
    
    public func getData<T, U>(parameters: [String], payload: U?, completion: @escaping (T?, ServiceError?) -> Void) {
        postDataCalled = payload as? Request
        spyArrayParameters = parameters
        completion((stubResponse as? T), stubError)
    }
    
    public var uploadCalled: Request?
    public var spyData: Data?    
    public func upload<T, U>(data: Data, parameters: [String : String], payload: U, completion: @escaping (T?, ServiceError?) -> Void) {
        spyData = data
        spyParameters = parameters
        uploadCalled = payload as? Request
        completion((stubResponse as? T), stubError)
    }

    public func subscribeToCache<T>(changes: @escaping (T?, ServiceError?) -> Void) {
        guard let response = stubResponse as? T else {
            changes(nil, stubError)
            return
        }
        changes(response, nil)
    }
    
    var capturedChanges: ((Request?, ServiceError?) -> Void)?
    public func subscribeToCache<T>(with parameters: [String : String], changes: @escaping (T?, ServiceError?) -> Void) {
        capturedChanges = changes as? ((Request?, ServiceError?) -> Void)
    }
    
    var capturedUpdate: ((Request?, ServiceError?) -> Void)?
    public func fetchCache<T>(parameters: [String : String], update: @escaping (T?, ServiceError?) -> Void) {
        capturedUpdate = update as? ((Request?, ServiceError?) -> Void)
    }
    
    public func fetchCacheList<T>(parameters: [String : String], update: @escaping (T?, ServiceError?) -> Void) {
        capturedUpdate = update as? ((Request?, ServiceError?) -> Void)
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
