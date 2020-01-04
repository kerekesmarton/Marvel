///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public class AdaptiveContainerView: UIView {

    //MARK: - Properties
    let defaultMargin:CGFloat = 15
    public var marginInsets: UIEdgeInsets? {
        didSet{
            if oldValue != marginInsets {
                adjust(marginInsets: marginInsets)
            }
        }
    }
    private var marginConstraints: [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        
        return superview.constraints
            .filter({( $0.firstItem as? UIView == self || $0.secondItem as? UIView == self )})
            .filter({ ($0.firstAnchor == self.topAnchor) || ($0.firstAnchor == self.leadingAnchor) || ($0.firstAnchor == superview.bottomAnchor) || ($0.firstAnchor == superview.trailingAnchor) })
    }
    
    
    //MARK: - Lifecycle methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        adjust(marginInsets: marginInsets)
    
    }
    
    func adjust(marginInsets: UIEdgeInsets?){
        
        guard let superview = superview else { return }
        self.marginInsets = marginInsets
        
        for marginConstraint in marginConstraints {
            
            if marginConstraint.firstAnchor == self.topAnchor{
                marginConstraint.constant = marginInsets?.top ?? defaultMargin
            }
            else if marginConstraint.firstAnchor == self.leadingAnchor{
                marginConstraint.constant = marginInsets?.left ?? defaultMargin
            }
            if marginConstraint.firstAnchor == superview.bottomAnchor{
                marginConstraint.constant = marginInsets?.bottom ?? defaultMargin
            }
            if marginConstraint.firstAnchor == superview.trailingAnchor{
                marginConstraint.constant = marginInsets?.right ?? defaultMargin
            }
            
        }
        
    }
    
}
