//
//  Domain
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public struct FeatureFlags: Equatable {
    public var uploadVideo: Bool
    public var searchTabs: Bool
    public var mention: Bool
    
    public init(defaults: DefaultSettings) {
        searchTabs = defaults.bool(forKey: FeatureFlags.searchTabsKey)
        mention = defaults.bool(forKey: FeatureFlags.mentionKey)
        uploadVideo = defaults.bool(forKey: FeatureFlags.uploadVideoKey)
    }
    
    public init(uploadVideo: Bool, searchTabs: Bool, mention: Bool) {
        self.uploadVideo = uploadVideo
        self.searchTabs = searchTabs
        self.mention = mention
    }
}

public extension FeatureFlags {
    static let uploadVideoKey: String = "FeatureFlags.UploadVideo"
    static let searchTabsKey: String = "FeatureFlags.SearchTabs"
    static let mentionKey: String = "FeatureFlags.Mention"
}
