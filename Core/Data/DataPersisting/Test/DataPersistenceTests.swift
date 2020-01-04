//
//  DataTests
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Realm
@testable import Domain
@testable import Additions
@testable import Data

class DataPersistenceTests: XCTestCase {
    
    var realm: Realm!
    var persistence: DataPersistence<StubEntity, StubModel>!
    override func setUp() {
        super.setUp()        
        do {
            realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: Constants.identifier))
        } catch  {
            print(error.localizedDescription)
        }
        createStub("test")
        
        persistence = DataPersistence(identifier: Constants.identifier)
    }
    
    func testGivenInitialResult_WhenFetching_ThenEntitiesReturned() {
        persistence.realm = realm
        var capturedResults: StubEntity?
        let exp = expectation(description: "waiting for realm")
        persistence.fetch(with: [:]) { (results: StubEntity?, error) in
            capturedResults = results
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(capturedResults?.field, "test")
    }
    
    @discardableResult fileprivate func createStub(_ value: String) -> StubModel {
        let stubModel = StubModel(field: value)
        try! realm.write {
            realm.add(stubModel)
        }
        return stubModel
    }
    
    private struct Constants {
        static let identifier = "TestPersistence"
    }
    
}

@objcMembers
class StubModel: Object, Model {
    func generateEntity() throws -> StubEntity {
        return StubEntity(field: field)
    }
    
    required init(from entity: StubEntity) throws {
        self.field = entity.field
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return true
    }
    
    typealias Entity = StubEntity
    
    dynamic var field: String = ""
    
    init(field: String) {
        super.init()
        self.field = field        
    }
    
    required public init() {
        super.init()
    }
    
    required public init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required public init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    open override class func primaryKey() -> String? { return "field" }
}
