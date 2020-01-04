///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation

class SmallImagePickerCell: ImageTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override var didTap: Tap? {
        didSet {
            button.setImage(nil, for: .normal)
        }
    }
    
    public override func applyStyle() {
        guard let imageView = customImageView as? RoundedImageView, let cellStyle = styleProvider?.cells else { return }
        
        imageView.applyStyle()
        imageView.backgroundColor = cellStyle.actions.secondLabel.color
        
        button.setTitleColor(cellStyle.common.backgroundColor, for: .normal)
        button.titleLabel?.font = cellStyle.actions.secondLabel.font
        button.tintColor = cellStyle.common.backgroundColor
    }
}
