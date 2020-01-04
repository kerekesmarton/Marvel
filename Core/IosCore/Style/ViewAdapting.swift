///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

public protocol ViewAdapting {
    func adaptMargins(top: Float, left: Float, bottom: Float, right: Float)
}

public enum Margin {
    public static let marginDefault: Float = 15
    public static let marginDefaultBig: Float = 25

    case defined(Float)
}


public extension ViewAdapting where Self: UITableViewCell {
    func adaptMargins(top: Float = Margin.marginDefault,
                      left: Float = Margin.marginDefault,
                      bottom: Float = Margin.marginDefault,
                      right: Float = Margin.marginDefault) {
        
        adaptableView?.marginInsets = .init(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right))
    }
    
    var adaptableView: AdaptiveContainerView? {
        return UIView.findView(ofType:AdaptiveContainerView.self, from: contentView)
    }
}
