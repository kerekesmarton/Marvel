//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class RoundedActionButton: UIButton, Styleable {
    
    var style: RoundedButtonStyle? {
        return styleProvider?.controls?.roundedButton
    }
    
    public func applyStyle() {
        layer.cornerRadius = style?.cornerRadius ?? 4
        layer.borderWidth = style?.borderWidth ?? 4
        layer.borderColor = style?.borderColor?.cgColor
        
//        setTitleColor(style?.titleColor, for: .normal)
//        titleLabel?.font = style?.titleFont
    }
    
}
