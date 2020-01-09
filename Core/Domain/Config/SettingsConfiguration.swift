///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public protocol SettingsConfigurable {
    func register()
    var environment: Environment { get }
    var tenant: TenantDescription { get }
    var featureFlags: FeatureFlags? { get }
    var delegate: SettingsConfigurableDelegate? { get set }
}

public protocol SettingsConfigurableDelegate: class {
    func settingsDidChange()
}

public protocol DefaultSettings {
    func bool(forKey defaultName: String) -> Bool
    func string(forKey defaultName: String) -> String?
    func set(_ value: Any?, forKey defaultName: String)
    @discardableResult func synchronize() -> Bool
}

extension UserDefaults: DefaultSettings {}

public class SettingsConfiguration: SettingsConfigurable {
    
    var registeredSettings = [String: String]()
    public weak var delegate: SettingsConfigurableDelegate?
    private let defaults: DefaultSettings
    
    public init(defaults:DefaultSettings) {
        self.defaults = defaults
    }
    
    private func setVersionString() {
        
        guard let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
            let buidlVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String,
            let id = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
                return
        }
        
        defaults.set(bundleVersion, forKey: "version_identifier")
        defaults.set(buidlVersion, forKey: "build_identifier")
        defaults.set(name, forKey: "CFBundleDisplayName")
        defaults.set(id, forKey: "CFBundleIdentifier")
        defaults.synchronize()
    }
    
    public func register() {
        registeredSettings[Environment.key] = Environment(defaults: defaults).rawValue
        
        featureFlags = FeatureFlags(defaults: defaults)
        setVersionString()
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChanged(_:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc func settingsChanged(_ notification: Notification) {
        let newEnvironment = Environment(defaults: defaults).rawValue
        if  registeredSettings[Environment.key] != newEnvironment {
            registeredSettings[Environment.key] = newEnvironment
            delegate?.settingsDidChange()
        }
    }
    
    public var featureFlags: FeatureFlags?
    
    public var environment: Environment {
        guard let savedValues = registeredSettings[Environment.key] else { return Environment.prod }
        guard let safeEnv = Environment(rawValue: savedValues) else { return Environment.prod }
        return safeEnv
    }
    
    public var tenant: TenantDescription {
        return TenantDescription(defaults: defaults, environment: environment)
    }
}

public class MockSettingsConfigurable: SettingsConfigurable {
    
    private let defaults: DefaultSettings
    public weak var delegate: SettingsConfigurableDelegate?
    
    public init(defaults:DefaultSettings) {
        self.defaults = defaults
    }
    public func register() {}
    
    public var tenant: TenantDescription {
        return TenantDescription(publicKey: "Std", privateKey: "0332c19e-1f14-4ca2-a8f9-783112c04cf6")
    }
    
    public var featureFlags: FeatureFlags? {
        return FeatureFlags(defaults: defaults)
    }
    
    public var environment: Environment {
        return Environment.prod
    }
}
