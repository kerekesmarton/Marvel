///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class ActionRoundedButton: ActionButton {

    override public func applyStyle() {
        super.applyStyle()
        
        guard let style = style else { return }
        layer.cornerRadius = style.cornerRadius
        layer.borderWidth = style.borderWidth
        clipsToBounds = true
        
        switch state {
        case .normal:
            layer.borderColor = style.activeBorderColor.cgColor
        case .selected:
            layer.borderColor = style.selectedBorderColor.cgColor
        case .disabled:
            layer.borderColor = style.disabledBorderColor.cgColor
        default:
            break
        }
        
    }

}
