///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public class DictionaryCoder: Codable {
    
    public let dictionary: [String: Any]
    
    public init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
    
    required public init(from decoder: Decoder) throws {
        if let values = try? [String: CodablePrimitive](from: decoder) {
            dictionary = values.mapValues({ (codablePrimitive) -> Any in
                return codablePrimitive.value
            })
        } else {
            dictionary = [:]
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        let codablePrimitiveDictionary: [String: CodablePrimitive] = dictionary.mapValues { (value) -> CodablePrimitive in
            if let value = value as? Int {
                return .int(value)
            } else if let value = value as? String {
                return .string(value)
            } else if let value = value as? Bool {
                return .bool(value)
            } else {
                return .string("")
            }
        }
        
        try codablePrimitiveDictionary.encode(to: encoder)
    }
}

enum CodablePrimitive: Codable {
    
    init(from decoder: Decoder) throws {
        if let value = try? String(from: decoder) {
            self = .string(value)
        } else if let value = try? Int(from: decoder) {
            self = .int(value)
        } else if let value = try? Bool(from: decoder) {
            self = .bool(value)
        } else {
            self = .string("")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .int(let value):
            try value.encode(to: encoder)
        case .bool(let value):
            try value.encode(to: encoder)
        case .string(let value):
            try value.encode(to: encoder)
        }
    }
    
    case string(String)
    case bool(Bool)
    case int(Int)
    
    var value: Any {
        switch self {
        case .int(let value):
            return value
        case .bool(let value):
            return value
        case .string(let value):
            return value
        }
    }
}
