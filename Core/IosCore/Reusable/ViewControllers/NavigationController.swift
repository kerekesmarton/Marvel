//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Domain

open class NavigationController: UINavigationController, Styleable {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        delegate = self
    }
    
    //MARK: - Stylable
    
    public func applyStyle() {
        view.backgroundColor = styleProvider?.navigation?.standard.backgroundColor
        navigationBar.tintColor = styleProvider?.navigation?.standard.barTintColour
        navigationBar.barTintColor = styleProvider?.navigation?.standard.backgroundColor
        navigationBar.isTranslucent = styleProvider?.navigation?.standard.translucency ?? false
        
        navigationBar.shadowImage = nil
        navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        
        guard let titleStyle = styleProvider?.navigation?.standard.titleLabel, let titleColor = titleStyle.color, let titleFont = titleStyle.font  else { return }
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : titleColor,
                                             NSAttributedString.Key.font : titleFont]
    }
    
    func setupBackButtonStyle(for viewController: UIViewController) {
        CATransaction.begin()
        let topItem = navigationBar.topItem
        navigationBar.backIndicatorImage = nil
        navigationBar.backIndicatorTransitionMaskImage = nil
        topItem?.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        CATransaction.commit()
    }
}

extension NavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    public func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        setupBackButtonStyle(for: viewController)
    }
}

extension NavigationController: UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate, ToastPresentationStyleable {
    
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
