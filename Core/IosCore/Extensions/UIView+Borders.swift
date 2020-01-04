//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBorder(edge: UIRectEdge, color: UIColor, borderWidth: CGFloat) {
        
        let seperator = UIView()
        self.addSubview(seperator)
        seperator.accessibilityIdentifier = "seperator"
        seperator.translatesAutoresizingMaskIntoConstraints = false
        
        seperator.backgroundColor = color
        
        if edge == .top || edge == .bottom
        {
            seperator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            seperator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            seperator.heightAnchor.constraint(equalToConstant: borderWidth).isActive = true
            
            if edge == .top
            {
                seperator.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            }
            else
            {
                seperator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            }
        }
        else if edge == .left || edge == .right
        {
            seperator.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            seperator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            seperator.widthAnchor.constraint(equalToConstant: borderWidth).isActive = true
            
            if edge == .left
            {
                seperator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            }
            else
            {
                seperator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            }
        }
    }
    
    func applyBorderStyle(color: UIColor?){
        guard let borderColor = color else {
            return
        }
        
        for view in subviews where view.accessibilityIdentifier == "seperator"{
            view.backgroundColor = borderColor
        }
    }
}
