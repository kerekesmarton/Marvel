///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit


public class Label: UILabel, Styleable {
    
    var style: LabelStyle? {
        didSet{
            applyStyle()
        }
    }
    
    public func applyStyle() {
        font = style?.font ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        textColor = style?.color
    }
}
