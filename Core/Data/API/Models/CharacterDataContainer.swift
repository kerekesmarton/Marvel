//
//  CharacterDataContainer.swift
//  Data
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Domain
import Realm
import RealmSwift

class CharacterDataContainer: Object, Codable, Model {
    func generateEntity() throws -> Entities.CharacterDataContainer {
        return Entities.CharacterDataContainer(offset: offset,
                                               limit: limit,
                                               total: total,
                                               count: count,
                                               results: try results?.compactMap { try $0.generateEntity() })
    }
    
    required init(from entity: Entities.CharacterDataContainer) throws {
        offset = entity.offset
        limit = entity.limit
        total = entity.total
        count = entity.count
        results = try entity.results?.compactMap { try Character(from: $0) }
        super.init()
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return results?.reduce(true, { (result, character) -> Bool in
            return result && character.matches(parameters: parameters)
        }) ?? false
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init()
    }
    
    var offset: Int? // The requested offset (number of skipped results) of the call.,
    var limit: Int? // The requested result limit.,
    var total: Int? // The total number of resources available given the current filter set.,
    var count: Int? // The total number of results returned by this call.,
    var results: [Character]? // The list of characters returned by the call.
    
    typealias Entity = Entities.CharacterDataContainer
}
