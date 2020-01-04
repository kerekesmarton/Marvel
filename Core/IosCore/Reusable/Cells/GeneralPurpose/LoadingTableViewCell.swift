//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(spinner)
        spinner.startAnimating()
    }

    var spinner = UIActivityIndicatorView(style: .gray)
}
