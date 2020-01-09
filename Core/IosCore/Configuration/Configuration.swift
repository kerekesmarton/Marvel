//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Data
import Additions
import Photos
import Reqres

public class Configuration: Configurable {
    
    //MARK: - Properties
    public static let shared = Configuration()
    let queue: OperationQueue
    var mainStartupOperation: BlockOperation?
    var dispatcher: Dispatching = Dispatcher()
    
    public var keychain: (KeychainLoading & SessionCleaning) {
        if ProcessInfo().isUITesting {
            return MockKeychainWrapper()
        } else {
            return KeyChainWrapper()
        }
    }
    public var featureFlags: FeatureFlags? = nil
    
    
    //MARK: - Constructor
    private init() {
        queue = OperationQueue()
        notificationServices.config = self
    }
    
    
    //MARK: - Configurable implementation
    public var appModules: ApplicationModules = ModuleTable.shared
    
    public lazy var settings: SettingsConfigurable = {
        if ProcessInfo().isUITesting {
            return MockSettingsConfigurable(defaults: ProcessInfo())
        } else {
            return SettingsConfiguration(defaults: UserDefaults.standard)
        }
    }()
    
    public var session: Sessionable {
        if ProcessInfo().isUITesting {
            return MockURLSession.shared
        } else {
            return URLSession.shared
        }
    }
    
    public var notificationServices: NotificationServiceable & NotificationRefreshable = {
        let notificationService = NotificationServicesInstance.shared
        return notificationService
    }()
    
    public var userProfileStore: UserProfileStoring {
        if ProcessInfo().isUITesting {
            return MockUserProfileStore(defaults: ProcessInfo())
        } else {
            return UserProfileStore()
        }
    }

    public var photosFetching: PhotosDataFetching = PhotosDataStore(imageManager: PHImageManager())
    
    public var uniqueStringProviding: UniqueStringProviding {
        if ProcessInfo().isUITesting {
            return MockUniqueStringProviding(defaults: ProcessInfo())
        } else {
            return UniqueStringProvider()
        }
    }
    
    public func loadConfiguration(didFinish: @escaping ()-> Void) {
        let didFinishOperation = BlockOperation(block: {
            self.dispatcher.dispatchMain {
                didFinish()
                self.setupServices()
            }
        })
        
        queue.addOperations([didFinishOperation], waitUntilFinished: true)
        
        self.mainStartupOperation = didFinishOperation
    }
    
    public func addToLoad(block: @escaping () -> Void) {
        
        let newOperation = BlockOperation {
            self.dispatcher.dispatchMain {
                block()
            }
        }
        
        guard let op = mainStartupOperation else { return }
        newOperation.addDependency(op)
        
        queue.addOperation(newOperation)
    }
    
    
    //MARK: - Private methods
    private func setupServices() {
        #if DEBUG
        Reqres.register()
        #endif
    }
}


extension ProcessInfo: DefaultSettings {
    
    public func bool(forKey defaultName: String) -> Bool {
        guard let value = Bool(ProcessInfo().environment[defaultName] ?? "") else { return false }
        return value
    }
    
    public func string(forKey defaultName: String) -> String? {
        return ProcessInfo().environment[defaultName]
    }
    
    public func set(_ value: Any?, forKey defaultName: String) {}
    
    public func synchronize() -> Bool { return true }
    
}
