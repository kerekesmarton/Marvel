//
//  Additions
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        if index >= 0, index < self.count {
            return self[index]
        }
        return nil
    }
}
