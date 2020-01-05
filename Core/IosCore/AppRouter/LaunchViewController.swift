///
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import UIKit

public class LaunchViewController: ViewController {
    
    public static var viewController: LaunchViewController {
        //BUG HERE
        return UIStoryboard.viewController(with: "LaunchViewController", storyboard: "UI", bundle: Bundle(for: self)) as! LaunchViewController
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
     
        loader.isHidden = false
        loader.startAnimating()
    }
    
    @IBOutlet var loader: UIActivityIndicatorView!
    
}
