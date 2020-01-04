//
//  ViewController.swift
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Presentation
import Domain

open class ViewController: UIViewController, Styleable, PresentationOutput {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        applyStyle()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open func applyStyle() {
        let style = styleProvider?.navigation?.standard
        guard let titleStyle = style?.titleLabel, let titleColor = titleStyle.color, let titleFont = titleStyle.font  else { return }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : titleColor,
                                                                   NSAttributedString.Key.font : titleFont]
    }

    open var state: PresentationOutputState? {
        didSet {
            switch state {
            case .loading:
                showActivityIndicatorOn(view)
            default:
                removeActivityIndicator()
            }
        }
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate, ToastPresentationStyleable {
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
