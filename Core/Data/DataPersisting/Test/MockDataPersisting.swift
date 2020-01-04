//
//  DataTests
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

@testable import Domain
@testable import Data

class MockDataPersisting: DataPersisting {
    var stubItems: StubEntity?
    var stubError: ServiceError?
    
    func fetch<T>(with parameters: [String : String]) -> T? {
        return stubItems as? T
    }
    
    func fetch<T>(with parameters: [String : String], fetchResult: @escaping (T?, ServiceError?) -> Void) {
        fetchResult(stubItems as? T, stubError)
    }
    
    func notifyChanges<T>(with parameters: [String : String], fetchResult: @escaping (T?, ServiceError?) -> Void) {
        fetchResult(stubItems as? T, stubError)
    }
    
    func invalidateUpdates() { }
    
    func save<T>(payload: T, completion: @escaping (ServiceError?) -> Void) {}
    
    func delete<T>(payload: T, deleteResult: @escaping (ServiceError?) -> Void) {}
    func deleteAll(deleteResult: @escaping (ServiceError?) -> Void) { }
}
