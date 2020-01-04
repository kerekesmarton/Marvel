//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

extension UIView {
    
    func maskSideCorners(edge: UIRectEdge, border width: CGFloat, corner radius: CGFloat, color: UIColor){
        
        clipsToBounds = false
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.cornerRadius = radius
        
        if edge == .left{
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
        else if edge == .right{
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
}
