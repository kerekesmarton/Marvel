//
//  UI
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    class func viewController(with name: String, storyboard: String, bundle: Bundle? = nil) -> UIViewController {
        let storyBoard = UIStoryboard(name: storyboard, bundle: bundle)
        return storyBoard.instantiateViewController(withIdentifier: name)
    }
}
