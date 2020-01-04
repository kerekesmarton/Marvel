//
//  Data
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public struct ErrorResponse: Codable {
    public var message: String
    public var error: String
    public var status: Int
    public var path: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case error
        case status
        case path
    }
}
