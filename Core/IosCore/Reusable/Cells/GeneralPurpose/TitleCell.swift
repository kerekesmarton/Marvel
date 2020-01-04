//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Domain

public final class TitleCell: UITableViewCell, Styleable {
    
    @IBOutlet public weak var titleLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
    public func applyStyle() {
        let cellStyle = styleProvider?.cells?.listCell
        
        titleLabel.font = cellStyle?.infoLabel.font
        titleLabel.textColor = cellStyle?.nameLabel.color
    }
    
}
