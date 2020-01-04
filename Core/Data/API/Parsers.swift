//
//  Parsers.swift
//  Data
//
//  Created by Marton Kerekes on 03/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain

class CharacterDataParser: DataParsing {
    func decode<T>(from data: Data, source: URL?) throws -> T {
        do {
            let result = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
            guard let entity = try result.generateEntity() as? T else {
                throw ServiceError.parsing("Entities.CharacterDataWrapper")
            }
            return entity
        } catch {
            throw findServiceError(data) ?? error
        }
    }
}

class CharacterDataEncoder: DataEncoding {
    func encode<U>(from entity: U) throws -> Data? {
        guard let e = entity as? Entities.CharacterDataWrapper else {
            throw ServiceError.parsing("Entities.CharacterDataWrapper")
        }
        let request: CharacterDataWrapper = try model(from: e)
        return try JSONEncoder().encode(request)
    }
    
    func model<U, T>(from entity: U) throws -> T where T : Model {
        
        guard let e = entity as? Entities.CharacterDataWrapper else {
            throw ServiceError.parsing("Entities.CharacterDataWrapper")
        }
        guard let m = try CharacterDataWrapper(from: e) as? T else {
            throw ServiceError.parsing("Entities.CharacterDataWrapper")
        }
        return m
    }
}
