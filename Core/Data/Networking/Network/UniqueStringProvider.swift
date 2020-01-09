//
//  UniqueStringBuilder.swift
//  Data
//
//  Created by Marton Kerekes on 09/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain

public class UniqueStringProvider: UniqueStringProviding {
    public var uniqueString: String {
        return UUID().uuidString
    }
    
    public init() {}
}
