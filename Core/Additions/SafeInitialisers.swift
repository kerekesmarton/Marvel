//
//  SafeInitialisers.swift
//  Additions
//
//  Created by Marton Kerekes on 03/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation

public extension Int {
    init?(safe value: String?) {
        guard let value = value, let safeInt = Int(value) else { return nil }
        self = safeInt
    }
}

public extension String {
    init?(safe value: String?) {
        guard let value = value else { return nil }
        self = value
    }
}

public extension Bool {
    init?(safe value: String?) {
        guard let value = value else { return nil }
        if value == "true" {
            self = true
        } else if value == "false" {
            self = false
        } else {
            return nil
        }
    }
}

public extension URL {
    init?(safe string: String?) {
        guard let string = string else { return nil }
        self.init(string: string)
    }
}
