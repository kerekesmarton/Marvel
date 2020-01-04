///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Presentation
import Domain
import ObjectiveC
import SnapKit

extension UIViewController: AppPresentingOutput  {
    
    struct AssociatedKeys {
        static var toastHandle: UInt8 = 0
        static var loadingHandle: UInt8 = 1
        static var dimViewHandle: UInt8 = 2
        static var indicatorViewKey: UInt8 = 3
    }
    
    private var toast: InAppMessageToastViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.toastHandle) as? InAppMessageToastViewController
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.toastHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadingHandle) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var greyView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.dimViewHandle) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.dimViewHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var loadingIndicator: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.indicatorViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.indicatorViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func showActivityIndicatorOn(_ view: UIView) {
        if loadingIndicator != nil {
            removeActivityIndicator()
        }
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        containerView.layer.cornerRadius = 5
        
        let indicator = UIActivityIndicatorView.init(style: .gray)
        
        containerView.addSubview(indicator)
        view.addSubview(containerView)
        view.bringSubviewToFront(containerView)
        
        containerView.snp.makeConstraints { (builder) in
            builder.width.height.equalTo(48)
            builder.center.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { (builder) in
            builder.center.equalToSuperview()
        }
        indicator.startAnimating()
        
        loadingIndicator = containerView
    }
    
    public func removeActivityIndicator() {
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil
    }
    
    public func show(message: InAppMessage, completion: DisplayInAppMessageResultBlock?) {
        if let toast = toast, !toast.message.isDeepLink {
            toast.dismiss(animated: true) { [weak self] in
                toast.didTapBlock?(.dismiss)
                self?.toast = nil
                self?._show(message: message, completion: completion)
            }
            return
        }
        _show(message: message, completion: completion)
    }
    
    private func _show(message: InAppMessage, completion: ((DisplayInAppMessageCompletion) -> Void)?) {
        guard message.shouldShow else {
            completion?(.dismiss)
            return
        }
        
        guard let style = (self as? ToastPresentationStyleable)?.style(for: message) else {
            #if DEBUG
                fatalError()
            #else
                return
            #endif
        }
        
        toast = InAppMessageToastViewController.toast(with: message, presentationStyle: style)
        toast!.didTapBlock = { [weak toast] resolution in
            toast?.dismiss(animated: true, completion: {
                completion?(resolution)
            })
        }
        setup(toast!)
        present(toast!, animated: true)
    }
    
    private func setup(_ toast: InAppMessageToastViewController) {
        guard let vc = self as? UIPopoverPresentationControllerDelegate & UIViewControllerTransitioningDelegate & ToastPresentationStyleable else {
            #if DEBUG
                fatalError()
            #else
                return
            #endif
        }
        
        toast.transitioningDelegate = vc
        toast.modalPresentationStyle = .custom
    }

    func makePresentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard let toast = presented as? InAppMessageToastViewController,
            let message = toast.message
            else { return nil }
        
        guard let style = (self as? ToastPresentationStyleable)?.style(for: message) else {
            #if DEBUG
                fatalError()
            #else
                return nil
            #endif
        }
        let controller = ToastMessagePresentationController(style: style, presentedViewController: presented, presenting: presenting ?? self)
        
        return controller
    }
    
    func makeAnimationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let toast = presented as? InAppMessageToastViewController,
            let message = toast.message
            else { return nil }
        
        guard let style = (self as? ToastPresentationStyleable)?.style(for: message) else {
            #if DEBUG
                fatalError()
            #else
                return nil
            #endif
        }
        return ToastPresentationAnimator(direction: style, isPresentation: true)
    }
    
    func makeAnimationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let toast = dismissed as? InAppMessageToastViewController,
            let message = toast.message
            else { return nil }
        
        guard let style = (self as? ToastPresentationStyleable)?.style(for: message) else {
            #if DEBUG
                fatalError()
            #else
                return nil
            #endif
        }
        return ToastPresentationAnimator(direction: style, isPresentation: false)
    }
}
