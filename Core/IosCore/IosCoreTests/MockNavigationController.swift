//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

class MockNavigationController: UINavigationController {
    
    var spyViewControllerToPresent: UIViewController?
    var spyDismissed = false
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        spyViewControllerToPresent = viewControllerToPresent
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        spyDismissed = true
    }
}

