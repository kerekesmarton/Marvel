//
//  ModelTests.swift
//  DataTests
//
//  Created by Marton Kerekes on 10/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import XCTest
@testable import Data
@testable import Domain
import Realm
import RealmSwift

class ModelTests: XCTestCase {
    
    func testCharacterDataWrapper_SavedToPersistence() throws {
        
        let savedEntity: Entities.CharacterDataWrapper = Entities.characters([Entities.johnAppleseed])
        let model = try CharacterDataWrapper(from: savedEntity)
    
        let realm = try RealmFactory.makeRealm(with: "test")
        try realm.write {
            realm.add(model, update: Realm.UpdatePolicy.modified)
        }
        
        let object = realm.objects(CharacterDataWrapper.self)
        
        let readEntity = try object.first?.generateEntity()
        
        XCTAssertEqual(readEntity?.data?.results?.first, Entities.johnAppleseed)
    }
    
    func testCharacter_SavedToPersistence() throws {
        
        let savedEntity: Entities.Character = Entities.johnAppleseed
        let model = try Character(from: savedEntity)
        
        let realm = try RealmFactory.makeRealm(with: "test")
        try realm.write {
            realm.add(model, update: Realm.UpdatePolicy.modified)
        }
        
        let anotherRealm = try! RealmFactory.makeRealm(with: "test")
        guard let readEntity = anotherRealm.objects(Character.self).first else {
            XCTFail()
            return
        }
        XCTAssertEqual(try readEntity.generateEntity(), savedEntity)
    }

}
