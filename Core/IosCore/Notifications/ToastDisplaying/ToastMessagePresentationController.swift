///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain


public enum ToastPresentationStyle {
    case top(totalHeight: CGFloat, topOffset: CGFloat)
    case bottom(totalHeight: CGFloat, bottomOffset: CGFloat)
}

public protocol ToastPresentationStyleable {
    /**
     - For message shown from the top with an offset covering the status bar (-20), 100 total height
     ````
     .top(totalHeight: 100, topOffset: -20)
     ````
     
     - For message shown from the bottom with an offset covering the tab bar bar (60), 60 total height
     ````
     .bottom(totalHeight: 60, bottomOffset: 60)
     ````
     */
    func style(for message: InAppMessage) -> ToastPresentationStyle
}

class ToastMessagePresentationController: UIPresentationController {
    
    let style: ToastPresentationStyle
    
    init(style: ToastPresentationStyle, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.style = style
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupTouchView()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        frame.origin.x = 0
        switch style {
        case .top(totalHeight: _, topOffset: let topOffset):
            frame.origin.y = topOffset
        case .bottom(totalHeight: let totalHeight, bottomOffset: let bottomOffset):
            frame.origin.y = containerView!.frame.height - totalHeight - bottomOffset
        }
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        switch style {
        case .top(totalHeight: let totalHeight, topOffset: _):
            return CGSize(width: parentSize.width, height: totalHeight)
        case .bottom(totalHeight: let totalHeight, bottomOffset: _):
            return CGSize(width: parentSize.width, height: totalHeight)
        }
    }
    
    private var touchView: UIView!
    func setupTouchView() {
        touchView = UIView()
        touchView.translatesAutoresizingMaskIntoConstraints = false
        touchView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        touchView.alpha = 0.0        
        touchView.addTapGestureRecognizer { [weak self] (tap) in
            self?.presentingViewController.dismiss(animated: true)
        }
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.frame = frameOfPresentedViewInContainerView
        containerView?.insertSubview(touchView, at: 0)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[touchView]|",
                                           options: [], metrics: nil, views: ["touchView": touchView!]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[touchView]|",
                                           options: [], metrics: nil, views: ["touchView": touchView!]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            touchView.alpha = 1.0
            presentedViewController.view.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.touchView.alpha = 1.0
            self.presentedViewController.view.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            touchView.alpha = 0.0
            presentedViewController.view.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { (_) in
            self.touchView.alpha = 0.0
            self.presentedViewController.view.alpha = 0.0
        }) { (_) in
            self.touchView.removeFromSuperview()
        }
    }
}
