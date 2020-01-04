//
//  UI
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Domain

open class TabBarController: UITabBarController, Styleable, TabbedPresenentationOutput {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        
        customizableViewControllers = []
    }
    
    public func applyStyle() {
        
        guard let tabBarStyle = styleProvider?.tabBar else { return }
        
        tabBar.isTranslucent = tabBarStyle.isTranslucent
        tabBar.barTintColor = tabBarStyle.barTintColor
        tabBar.tintColor = tabBarStyle.tintColor
        tabBar.unselectedItemTintColor = tabBarStyle.unselectedItemTintColor
        
        guard let font = UIFont(name: tabBarStyle.titleLabel.font?.fontName ?? "", size: tabBarStyle.titleLabel.font?.pointSize ?? 0) else { return }
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)

    }
}

extension TabBarController: UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate, ToastPresentationStyleable {
    
    public func style(for message: InAppMessage) -> ToastPresentationStyle {
        return .bottom(totalHeight: tabBar.frame.height, bottomOffset: 0)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return makePresentationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return makeAnimationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return makeAnimationController(forDismissed: dismissed)
    }
    
    public func updateNotificationsTabBadge(value: Int)  {
        guard let navVc = self.viewControllers?[safe:3] as? ClearNavigationController,
            let notificationsListVc = navVc.viewControllers.first as? NotificationsListPresentingOutput  else { return }
        notificationsListVc.setIconBadgeWith(number: value, tabIndex: 3)
    }
    
    public func redDotOnNotificationsTab() {
        guard let navVc = self.viewControllers?[safe:3] as? ClearNavigationController,
            let notificationsListVc = navVc.viewControllers.first as? NotificationsListPresentingOutput  else { return }
        notificationsListVc.setRedDotOnNotificationsTab(show: true)
    }
}
