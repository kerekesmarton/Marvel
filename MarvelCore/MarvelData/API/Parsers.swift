//
//  Parsers.swift
//  Data
//
//  Created by Marton Kerekes on 03/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import Data
import MarvelDomain

class CharacterDataParser: DataParsing {
    func decode<T>(from data: Data, source: URL?) throws -> T {
        do {
            let result = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
            guard let entity = try result.generateEntity() as? T else {
                throw ServiceError.parsing("Entities.CharacterDataWrapper")
            }
            result.id = source?.stringRemoving(params: ["apikey", "ts", "hash"]) ?? ""
            try persist(model: result)
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

class SeriesDataParser: DataParsing {
    func decode<T>(from data: Data, source: URL?) throws -> T {
        do {
            let result = try JSONDecoder().decode(SeriesDataWrapper.self, from: data)
            guard let entity = try result.generateEntity() as? T else {
                throw ServiceError.parsing("Entities.SeriesDataWrapper")
            }
            result.id = source?.stringRemoving(params: ["apikey", "ts", "hash"]) ?? ""
            try persist(model: result)
            return entity
        } catch {
            throw findServiceError(data) ?? error
        }
    }
}

struct GenericDataEncoder: DataEncoding {
    
    func model<U, T>(from entity: U) throws -> T where T : Model {
        switch entity.self {
        case is Entities.CharacterDataWrapper:
            return try CharacterDataEncoder().model(from: entity)
        case is Entities.SeriesDataWrapper:
            return try SeriedDataEncoder().model(from: entity)
        default:
            throw ServiceError.parsing("GenericDataEncoder: entity not found")
        }
    }
    
    func encode<U>(from entity: U) throws -> Data? {
        switch entity.self {
        case is Entities.CharacterDataWrapper:
            return try CharacterDataEncoder().encode(from: entity)
        case is Entities.SeriesDataWrapper:
            return try SeriedDataEncoder().encode(from: entity)
        default:
            throw ServiceError.parsing("GenericDataEncoder: entity not found")
        }
    }
}

class SeriedDataEncoder: DataEncoding {
    func encode<U>(from entity: U) throws -> Data? {
        guard let e = entity as? Entities.SeriesDataWrapper else {
            throw ServiceError.parsing("Entities.SeriesDataWrapper")
        }
        let request: SeriesDataWrapper = try model(from: e)
        return try JSONEncoder().encode(request)
    }
    
    func model<U, T>(from entity: U) throws -> T where T : Model {
        
        guard let e = entity as? Entities.SeriesDataWrapper else {
            throw ServiceError.parsing("Entities.SeriesDataWrapper")
        }
        guard let m = try SeriesDataWrapper(from: e) as? T else {
            throw ServiceError.parsing("Entities.SeriesDataWrapper")
        }
        return m
    }
}
