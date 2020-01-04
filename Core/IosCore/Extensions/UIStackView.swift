///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit


public extension UIStackView {
    
    func removeView(_ view: UIView?) {
        
        guard let view = view else { return }
        removeArrangedSubview(view)
        view.removeFromSuperview()
        
    }
    
}
