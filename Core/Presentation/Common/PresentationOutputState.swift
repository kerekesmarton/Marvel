///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public enum PresentationOutputState {
    case disabled
    case enabled
    case loading
}

public protocol PresentationOutput: class {
    var state: PresentationOutputState? { get set }
}
