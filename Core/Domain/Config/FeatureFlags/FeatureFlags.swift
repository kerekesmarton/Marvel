//
//  Domain
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public struct FeatureFlags: Equatable {
    public var searchTabs: Bool
    
    public init(defaults: DefaultSettings) {
        searchTabs = defaults.bool(forKey: FeatureFlags.searchTabsKey)
    }
    
    public init(uploadVideo: Bool, searchTabs: Bool, mention: Bool) {
        self.searchTabs = searchTabs
    }
}

public extension FeatureFlags {
    static let searchTabsKey: String = "FeatureFlags.SearchTabs"    
}
