///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

class LargeImagePickerCell: ImageTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        button.imageView?.contentMode = .scaleAspectFit
    }
    
    public override func applyStyle() {
        guard let cellStyle = styleProvider?.cells else {
            return
        }
        backgroundColor = cellStyle.common.backgroundColor
        button.backgroundColor = cellStyle.actions.secondLabel.color
        button.setTitleColor(cellStyle.common.backgroundColor, for: .normal)
        button.titleLabel?.font = cellStyle.actions.secondLabel.font
        button.tintColor = cellStyle.common.backgroundColor
        
        
        let cornerstyle = styleProvider?.controls?.roundedButton
        button.layer.cornerRadius = cornerstyle?.cornerRadius ?? 2
        button.layer.borderWidth = cornerstyle?.borderWidth ?? 2
        button.layer.borderColor = cornerstyle?.borderColor?.cgColor
        
        layer.masksToBounds = true
    }
}
