///
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public class TestHelper {
    public static var isUITesting: Bool {
        guard ProcessInfo().isUITesting else {
            return false
        }
        return true
    }
    
    public static var shouldShowWelcome: Bool {
        guard ProcessInfo().shouldShowWelcome else { return false }
        return true
    }
    
    public static var isTesting: Bool {
        return NSClassFromString("XCTest") != nil
    }
    
}

