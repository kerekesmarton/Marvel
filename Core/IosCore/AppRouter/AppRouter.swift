//
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Domain

public protocol ScrollableChildRouter {
    func scrollToTop()
}

public class AppRouter: NSObject, Routing, AppRouting, ErrorRouting {
    private struct Constants {
        static let addPostButtonIndex = 2
        static let tabBarItemImageInset = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    let window: UIWindow
    let style: StyleProviding
    public weak var delegate: AppRoutingDelegate?
    var tabs: TabBarController?
    var currentChildRouter: Routing?
    
    public init(window: UIWindow, style: StyleProviding) {
        self.window = window
        self.style = style
        style.setup()
    }
    
    private func setupTabBarController() -> TabBarController {
        
        let tabBarController = TabBarController()
        
        tabBarController.delegate = self
        window.rootViewController = tabBarController
        
        return tabBarController
        
    }
    
    public func start() {
        setupLoadingScreen()
    }
    
    fileprivate func findModule(_ moduleConfig: (NavigationConfiguration.Item), in appmodules: [TabModule]) -> TabModule? {
        return appmodules.first(where: { (tabModule) -> Bool in
            tabModule.tabIdentifier == moduleConfig.moduleName
        })
    }
    
    public func setupModules(navConfig: NavigationConfiguration) -> TabbedPresenentationOutput {
        
        let tabs = setupTabBarController()
        var controllers: [UINavigationController] = []
        let appmodules: [TabModule] = config.appModules.modules()
       
        navConfig.items.forEach({ (moduleConfig) in
            guard let appModule = findModule(moduleConfig, in: appmodules) else { return }

            let moduleResult = appModule.setup(title: moduleConfig.titleRes, image: moduleConfig.iconRes, config: config)
            addChild(router: moduleResult.router)
            moduleResult.controller.tabBarItem.imageInsets = Constants.tabBarItemImageInset
            controllers.append(moduleResult.controller as! UINavigationController)
            moduleResult.router.start()
        })
        tabs.setViewControllers(controllers, animated: false)
        currentChildRouter = childRouters?[safe: 0]?.router
        self.tabs = tabs
        return tabs
        
    }
    
    public func setupWelcomeScreen() {
        let welcomeModule: LoginModulable = config.appModules.module()
        let result = welcomeModule.setup(config: config) {[weak self] in
            self?.delegate?.didLogin()
        }
        
        window.rootViewController = result.controller
        addChild(router: result.router)
        result.router.start()
    }
    
    public func setupLoadingScreen() {        
        window.rootViewController = LaunchViewController.viewController
    }
    
    public func canHandle<T>(deepLink: DeepLinkOption<T>) -> Bool {
        return true
    }
    
    public func route<T>(deepLink: DeepLinkOption<T>) {
        route(tab: .notifications)
        guard let childRouter = childHandling(deepLink) else { return }        
        if let tabRouter = childRouter as? TabRoutable {
            tabs?.selectedIndex = tabRouter.tab
        }
        childRouter.route(deepLink: deepLink, stack: [])
    }
    
    public func route(tab: AppRoutableTabs) {
        switch tab {
        case .feed, .explore, .profile, .notifications:
            tabs?.selectedIndex = tab.rawValue
        case .createPost:
            //do something when tapped?
            ()
        }
        currentChildRouter = childRouters?[safe: tab.rawValue]?.router
    }
    
    public func doesRespond<T>() -> T? {
        switch T.self {
        case is InAppMessageRouting?.Type: //don't asky why it needs to be optional...
            if tabs?.presentedViewController == nil {
                return self as? T
            }
            return nil
        default:
            return self as? T
        }
    }
}

extension AppRouter: InAppMessageRouting {

    public func route(message: InAppMessage, completion: ((DisplayInAppMessageCompletion) -> Void)? = nil) {
        delegate?.displayInApp(message: message, completion: completion)
    }
}

extension AppRouter: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return false }
        if index == Constants.addPostButtonIndex {
            delegate?.createPost()
            return false
        } else if index == tabBarController.selectedIndex {
            if let router = currentChildRouter as? ScrollableChildRouter {
                router.scrollToTop()
            }
            return true
        } else {
            let weakRouter = childRouters?.first {
                guard let router = $0.router as? TabRoutable else {
                    return false
                }
                return router.tab == index
            }
            currentChildRouter = weakRouter?.router
            return true
        }
    }
}

public typealias UserDidFinishAuth = () -> ()

public protocol LoginModulable: Module {
    func setup(config: Configurable, didFinishAuth: @escaping UserDidFinishAuth) -> (controller: UIViewController, router: Routing)
}
