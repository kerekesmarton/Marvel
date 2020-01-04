//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Additions

public protocol Styleable {
    var styleProvider: StyleProviding? { get }
    func applyStyle()
}

public extension Styleable {
    var styleProvider: StyleProviding? {
        return StyleManager.shared.styleProvider
    }
}

public class StyleManager {
    public private(set) var styleProvider: StyleProviding?
    
    public static func create(provider: StyleProviding) throws {
        if StyleManager.shared.styleProvider == nil {
            StyleManager.shared.styleProvider = provider
        } else {
            throw NSError(with: "Already set, please use .shared", domain: "UI")
        }
    }

    private init(){}
    public static let shared: StyleManager = StyleManager()
}
