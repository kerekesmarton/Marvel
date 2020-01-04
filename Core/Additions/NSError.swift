//
//  Additions
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public extension NSError {
    convenience init(with userMessage: String, domain: String) {
        self.init(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: userMessage])
    }
}
