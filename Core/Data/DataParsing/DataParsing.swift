//
//  Data
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import RealmSwift

protocol Model: Equatable {
    associatedtype Entity
    func generateEntity() throws -> Entity
    init(from entity: Entity) throws
    func matches(parameters: [String: String]) -> Bool
}

protocol DataParsing {
    func decode<T>(from data: Data, source: URL?) throws -> T?
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
    func parse<T>(_ data: Data, source: URL? = nil) throws -> T?{        
        guard let result: T? = try decode(from: data, source: source) else {
            return nil
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

struct ErrorDataParser: DataParsing {
    func decode<T>(from data: Data, source: URL?) throws -> T? {
        guard let error = findServiceError(data) else { return nil }
        throw error
    }
}

protocol DataEncoding {
    func encode<U>(from entity: U) throws -> Data?
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
        default:
            throw ServiceError.parsing("GenericDataEncoder: entity not found")
        }
    }
    
    func encode<U>(from entity: U) throws -> Data? {
        return nil
    }
}
