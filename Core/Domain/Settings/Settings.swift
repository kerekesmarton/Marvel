///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public enum Settings: String, CaseIterable {
    case external
    
    public var title: String {
        return rawValue.localised
    }
}
