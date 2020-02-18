//
//  CharacterSegmentedContent.swift
//  MarvelDomain
//
//  Created by Marton Kerekes on 18/02/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Presentation
import MarvelDomain

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
