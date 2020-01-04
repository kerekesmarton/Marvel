//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class ProfileInfoCell: UITableViewCell, Styleable {
    
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var descriptionLabel: UILabel!
    
    public func applyStyle() {
        
        nameLabel.textColor = styleProvider?.list?.header.nameLabel.color
        nameLabel.font = styleProvider?.list?.header.nameLabel.font
        
        descriptionLabel.textColor = styleProvider?.list?.header.titleOneLabel.color
        descriptionLabel.font = styleProvider?.list?.header.titleOneLabel.font
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyle()
    }
}
