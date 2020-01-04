///
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import UIKit


class LaunchViewController: ViewController {
    
    static var viewController: LaunchViewController {
        //BUG HERE
        return UIStoryboard.viewController(with: "LaunchViewController", storyboard: "UI", bundle: Bundle(for: self)) as! LaunchViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        loader.isHidden = false
        loader.startAnimating()
    }
    
    @IBOutlet var loader: UIActivityIndicatorView!
    
}
