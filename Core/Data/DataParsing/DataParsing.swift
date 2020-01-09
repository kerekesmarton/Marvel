//
//  Data
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import RealmSwift

/// Description contained in data layer to abstract data transorfmations
protocol Model: Equatable {
    associatedtype Entity
    /// creates an instance of a the matching domain object
    func generateEntity() throws -> Entity
    /// initialise a data model from a domain object
    /// - Parameter entity: The domain object
    init(from entity: Entity) throws
    /// Used for matching persisted items
    /// - Parameter parameters: pass items to match against, usually a URI, Id, etc. dependends on implementation and API.
    func matches(parameters: [String: String]) -> Bool
}

protocol DataParsing {
    /**
     Parser data into a given domain object
     - Parameters:
     - data: data to be transformed
     - source: where the data is coming from
     */
    func decode<T>(from data: Data, source: URL?) throws -> T
}

struct ErrorModel: Codable, Model {
    var message: String
    
    func generateEntity() throws -> ErrorEntity {
        return ErrorEntity(message: message)
    }
    
    init(from entity: ErrorEntity) throws {
        message = entity.message
    }
    
    func matches(parameters: [String : String]) -> Bool {
        return false
    }
    
    typealias Entity = ErrorEntity
}

extension DataParsing {
    func parse<T>(_ data: Data, source: URL? = nil) throws -> T {
        guard let result: T = try decode(from: data, source: source) else {
            throw ServiceError.parsing("failed to parse")
        }
        return result
    }
    
    public func findServiceError(_ data: Data) -> ServiceError? {
        do {
            let errorResponse = try JSONDecoder().decode(ErrorModel.self, from: data)
            let entity = try errorResponse.generateEntity()
            return ServiceError.message(entity.message)
        } catch {
            return nil
        }
    }
    
    func persist<M: Object>(model: M) throws {
        let realm = try RealmFactory.makeRealm()
        try realm.write {
            realm.add(model, update: Realm.UpdatePolicy.modified)
        }
    }
    
    public var persisting: Bool {
        return false
    }
}

protocol DataEncoding {
    /**
     Parser a domain object into data
     - Parameter entity: The domain object to be transformed to data
     */
    func encode<U>(from entity: U) throws -> Data?
    
    /**
     Creates a data model from a domain object
     - Parameter entity:  The domain object
     */
    func model<U, T: Model>(from entity: U) throws -> T
}

extension DataEncoding {
    func parse<U>(from entity: U) throws -> Data? {
        guard let result = try encode(from: entity) else {
            throw ServiceError.unknown
        }
        return result
    }
}


public struct GenericDataEncoder: DataEncoding {
    
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
