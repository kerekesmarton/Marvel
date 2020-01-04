//
//  Data
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain

class ImageModel: Codable {
    var data: Data?
    var source: String?
    
    init(data: Data, source: URL) {
        self.data = data
        self.source = source.absoluteString
    }
}
