//
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public protocol NibViewLoadable: class {
    static var nib: UINib { get }
}

public extension NibViewLoadable where Self: UIView {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func makeFromNib() -> Self? {
        return nib.instantiate(withOwner: nil, options: nil).first as? Self
    }
    
    private func instantiateFromNib(owner: Any? = nil) -> UIView? {
        let view = Self.nib.instantiate(withOwner: owner, options: nil).first as? UIView
        return view
    }
    
    func loadFromNib() {
        guard let view = instantiateFromNib(owner: self) else {
            fatalError("Failed to instantiate nib \(Self.nib)")
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        let views = ["view": view]
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                 options: .alignAllLastBaseline, metrics: nil,
                                                                 views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                   options: .alignAllLastBaseline, metrics: nil,
                                                                   views: views)
        addConstraints(verticalConstraints + horizontalConstraints)
    }
    
}

