///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public struct BasicInfo {
    var displayableText: [FontCalculable]
    var tick: Bool
    
    public init(displayableText: [FontCalculable], tick: Bool) {
        self.displayableText = displayableText
        self.tick = tick
    }
}

public struct PresentableInfo {
    public let name: NSAttributedString
    public let details: NSAttributedString?
    public let links: [String]?
    public let verified: Bool
    public var nameTap: Tap?
    public var detailsTap: Tap?
    public var linkTap: LinkTap?
    
    public init(name: NSAttributedString, details: NSAttributedString? = nil, links: [String]? = nil, verified: Bool) {
        self.name = name
        self.details = details
        self.verified = verified
        self.links = links
    }
    
    public init(info: BasicInfo, helper: FontCalculating) {
        let fullName = helper.makeAttributedString(from: info.displayableText)
        self.init(name: fullName, verified: info.tick)
    }
}

public enum ListType {
    case buttonWithOptions(Bool)
    case button(Bool)
    case selection(Bool)
    case options(Bool)
    case none
}

public protocol PresentableItem: class {
    func setup(profileInfo: PresentableInfo, title: String?, imageURL: URL?, type: ListType)
    func setup(action: @escaping  ((IndexPath) -> Void))
}
