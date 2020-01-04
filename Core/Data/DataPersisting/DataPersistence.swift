//
//  Data
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import RealmSwift
import Domain
import Additions
import Realm

public class RealmFactory {
    public static func makeRealm(with identifier: String? = nil) throws -> Realm {
        let id = identifier ?? (TestHelper.isUITesting ? "uitesting" : nil)
        let config = Realm.Configuration(inMemoryIdentifier: id, deleteRealmIfMigrationNeeded: true)
        return try Realm(configuration: config)
    }
}

protocol DataPersisting {
    func fetch<T>(with parameters: [String: String]) -> T?
    func fetch<T>(with parameters: [String: String], fetchResult: @escaping (T?, ServiceError?)-> Void)
    
    func notifyChanges<T>(with parameters: [String: String], fetchResult: @escaping (T?, ServiceError?)-> Void)
    func invalidateUpdates()
    
    func deleteAll(deleteResult: @escaping (ServiceError?)-> Void)
}

class DataPersistence<E, M: Model & Object>: DataPersisting {
    
    lazy var realm: Realm? = {
        return try? RealmFactory.makeRealm(with: identifier)
    }()
    
    var identifier: String?
    public init(identifier: String? = nil) {
        self.identifier = identifier
    }

    var notificationToken: NotificationToken?
    var objects: Results<M>?
    var updateBlock: ((E?, ServiceError?)-> Void)?
    
    private func filterResults(with parameters: [String: String], from results: Results<M>, deletions: [Int]? = nil, insertions: [Int]? = nil, modifications: [Int]? = nil) -> E? {

        var filtered = [M]()
        insertions?.forEach({ (i) in
            filtered.append(results[i])
        })
        modifications?.forEach({ (i) in
            filtered.append(results[i])
        })

        let entity: E? = convert(with: parameters, results: filtered)
        return entity
    }

    private func results<T>(with parameters: [String: String], changes:RealmCollectionChange<Results<M>>, fetchResult: @escaping (T?, ServiceError?) -> Void) {
        guard case .update(let results, deletions: let deletions, insertions: let inserted, modifications: let modified) = changes else {
            return
        }
        guard let finalResults: E = filterResults(with: parameters, from: results, deletions:  deletions, insertions: inserted, modifications: modified) else { return }
        
        updateBlock?(finalResults, nil)
    }
    
    private func convert(with parameters: [String : String], results: [M]) -> E? {
        let filteredResults = results.filter {
            return $0.matches(parameters: parameters)
        }
        guard let model = filteredResults.first else {
            return nil
        }
        do {
            let entity = try model.generateEntity()
            return entity as? E
        } catch {
            return nil
        }
    }
    
    public func fetch<T>(with parameters: [String : String]) -> T? {
        guard let realm = realm else { return nil }
        let objects = realm.objects(M.self)
        let mapped: [M] = objects.map() { $0 }
        guard let model = convert(with: parameters, results: mapped) as? T else {
            return nil
        }
        return model
    }
    
    public func fetch<T>(with parameters: [String: String], fetchResult: @escaping (T?, ServiceError?) -> Void) {
        guard let realm = realm else { return }
        let objects = realm.objects(M.self)
        let filteredResults = objects.filter {
            return $0.matches(parameters: parameters)
        }
        guard let model = filteredResults.first else { return }
        do {
            let entity = try model.generateEntity() as? T
            fetchResult(entity, nil)
        } catch {
            fetchResult(nil, ServiceError(from: error))
        }    
    }
    
    public func notifyChanges<T>(with parameters: [String: String], fetchResult: @escaping (T?, ServiceError?) -> Void) {
        updateBlock = fetchResult as? ((E?, ServiceError?) -> Void)
        guard let realm = realm else { return }
        let objects = realm.objects(M.self)
        
        notificationToken = objects.observe { [weak self] (changes) in
            self?.results(with: parameters, changes: changes, fetchResult: fetchResult)
        }
    }
    
    public func invalidateUpdates() {
        notificationToken?.invalidate()
    }
    
    public func deleteAll(deleteResult: @escaping (ServiceError?)-> Void) {
        do {
            try realm?.write {
                realm?.deleteAll()
                deleteResult(nil)
            }
        } catch {
            deleteResult(ServiceError(from: error))
        }
    }
}
