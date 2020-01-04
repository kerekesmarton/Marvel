//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit

class PassThroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}

class NonPassThroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true
    }
}

class SubviewStoppingTouches: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.first { (subview) -> Bool in            
            return subview.frame.contains(point) && !hidden(view: subview)
        } != nil
    }
    
    func hidden(view: UIView) -> Bool {
        if view.isHidden {
            return true
        }
        return view.subviews.reduce(false, { (result, subView) -> Bool in
            return result && subView.isHidden
        })
    }
}

public class SubviewStoppingTouchesCollectionView: UICollectionView {
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.first { (subview) -> Bool in
            return viewWasTapped(subview, point, with: event)
            } != nil
    }
    
    func viewWasTapped(_ view: UIView, _ point: CGPoint, with event: UIEvent?) -> Bool {
        guard let emptyView = view as? EmptyStateView else {
            return view.point(inside: convert(point, to: view), with: event)
        }
        return emptyView.point(inside: convert(point, to: emptyView), with: event)
    }
}

public class SubviewStoppingTouchesTableView: UITableView {
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.first { (subview) -> Bool in
            return viewWasTapped(subview, point, with: event)
            } != nil
    }
    
    func viewWasTapped(_ view: UIView, _ point: CGPoint, with event: UIEvent?) -> Bool {
        guard let emptyView = view as? EmptyStateView else {
            return view.point(inside: convert(point, to: view), with: event)
        }
        return emptyView.point(inside: convert(point, to: emptyView), with: event)
    }
}
