///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public enum RowHeight {
    case set(Double)
    case automatic
    case screenSized
    case proportional(Double)
}

extension RowHeight: Equatable {
    public static func == (lhs: RowHeight, rhs: RowHeight) -> Bool {
        switch (lhs,rhs) {
        case (.automatic, .automatic), (.screenSized, .screenSized):
            return true
        case (.set(let lhsValue), .set(let rhsValue)):
            return lhsValue == rhsValue
        case (.proportional(let lhsValue), .proportional(let rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
}
