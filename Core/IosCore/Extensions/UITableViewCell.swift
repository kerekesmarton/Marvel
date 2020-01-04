///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit


extension UITableViewCell{

    var tableView: UITableView? {
        return superview as? UITableView
    }
    
}
