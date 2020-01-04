//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Domain

open class PageViewController: UIPageViewController, Styleable {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
    }
    
    public func applyStyle() {
        
    }
}

extension PageViewController: UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate, ToastPresentationStyleable {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return makePresentationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return makeAnimationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return makeAnimationController(forDismissed: dismissed)
    }
    
    public func style(for message: InAppMessage) -> ToastPresentationStyle {
        return .bottom(totalHeight: 60, bottomOffset: view.safeAreaInsets.bottom)
    }
}


