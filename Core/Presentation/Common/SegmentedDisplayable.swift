//
//  Presentation
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Domain

public protocol SegmentedDisplayable {
    var title: String { get }
}

public enum CharacterSegmentedContent: SegmentedDisplayable, Equatable {
    
    case series(character: Entities.Character)
    case bio(text: [FontCalculable])
    
    public var title: String {
        switch self {
        case .series(character: _):
            return "series"
        case .bio(text: _):
            return "bio".localised
        }
    }
    
    static public func == (lhs: CharacterSegmentedContent, rhs: CharacterSegmentedContent) -> Bool {
        switch (lhs, rhs) {
        case (.series(let l), .series(let r)):
            return l.resourceURI == r.resourceURI
        case (.bio(_), .bio(_)):
            return false
        default:
            return false
        }
    }
}
