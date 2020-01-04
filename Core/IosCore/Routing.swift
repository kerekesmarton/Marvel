//
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Domain
import Presentation
import UIKit
import SafariServices

public protocol TabModule: Module {
    var tabIdentifier: String { get }
    var tab: Int { get }
    func setup(title: String, image: String?, config: Configurable) -> (controller: UIViewController, router: Routing)
}

public extension TabModule {
    
    func createNavigation(with title: String, imageResource: String?, tag: Int) -> UINavigationController {
        let nav = ClearNavigationController()
        
        if let imageResource = imageResource {
            let item: UITabBarItem = UITabBarItem(title: title, image: UIImage(named: imageResource), tag: tag)
            item.accessibilityIdentifier = title
            nav.tabBarItem = item
        }
        else {
            let item: UITabBarItem = UITabBarItem(title: title, image: nil, tag: tag)
            item.accessibilityIdentifier = title
            nav.tabBarItem = item
        }
        
        return nav
    
    }
}

public protocol Routing: class {
    
    /**
     Global config object
     */
    var config: Configurable { get }
    /**
     Entry point to start module, preferable implementation should push viewController on navigation
     */
    func start()

    /**
     Reference to the parent router
     */
    var parent: Routing? { get set }
    
    /**
     Returns a child router handling a deep link. If a router handles a deeplink, just implement canHandle returning true, and route. If a known child can handle a deep link, return canHandle accordingly, then delegate work to specific child router.
     */
    func childHandling<T>(_ deepLink: DeepLinkOption<T>) -> Routing?
    /**
     Return true if router of a child router can handle the given link
     */
    func canHandle<T>(deepLink: DeepLinkOption<T>) -> Bool
    
    /**
     Handle the link
     */
    func route<T>(deepLink: DeepLinkOption<T>, stack: [UIViewController])
    
    func present(controller: UIViewController)
    
    func doesRespond<T>() -> T?
}

extension Routing {
    public var config: Configurable {
        guard NSClassFromString("XCTest") == nil else {
            return MockConfig.shared
        }
        return Configuration.shared
    }
    
    public weak var context: (UIViewController & AppPresentingOutput)? {
        get {
            guard let _context = objc_getAssociatedObject(self, &contextHandle) as? (UIViewController & AppPresentingOutput) else {
                return nil
            }
            return _context
        }
        set {
            objc_setAssociatedObject(self, &contextHandle, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public weak var parent: Routing? {
        get {
            guard let _parent = objc_getAssociatedObject(self, &parentHandle) as? Routing else {
                return nil
            }
            return _parent
        }
        set {
            objc_setAssociatedObject(self, &parentHandle, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func present(controller: UIViewController) {
        context?.present(controller, animated: true, completion: nil)
    }
    
    /**
     Handle the link
     */
    public func route<T>(deepLink: DeepLinkOption<T>, stack: [UIViewController]) {
        
    }
    
    /**
     Adds a child router
     */
    public func addChild(router: Routing) {
        router.parent = self
        childRouters?.append(WeakRouter(value: router))
        compact()
    }
    
    public func removeChild(router: Routing) {
        router.parent = nil
        childRouters = childRouters?.filter { $0.router !== router }
    }
    
    public func compact() {
        childRouters = childRouters?.filter {
            if $0.router != nil {
                $0.router?.compact()	
                return true
            }
            $0.router?.parent = nil
            return false
        }
    }
    
    public func doesRespond<T>() -> T? {
        return self as? T
    }
    
    /**
        Finds a router implementing a specific protocol going up to appRouter. returns first.
     */
    public func findResponder<T>() -> T? {
        if self is T {
            return self as? T
        }
        
        guard let responder = parent as? T else {
            return parent?.findResponder()            
        }
        
        if let router = responder as? Routing {
            return router.doesRespond() ?? parent?.findResponder()
        } else {
            return responder
        }
    }
    
    /**
     Set of objects having a weak reference to individual children routers
     */
    public var childRouters: [WeakRouter]? {
        get {
            if let children = objc_getAssociatedObject(self, &childRoutersHandle) as? [WeakRouter] {
                return children
            }
            let children = [WeakRouter]()
            self.childRouters = children
            return children
        }
        set {
            objc_setAssociatedObject(self, &childRoutersHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //MARK: - Deep Linking
    public func childHandling<T>(_ deepLink: DeepLinkOption<T>) -> Routing? {
        let child = childRouters?.first(where: { (child) -> Bool in
            guard let router = child.router else {
                return false
            }
            return router.canHandle(deepLink: deepLink)
        })
        
        guard let childRouter = child?.router else {
            return nil
        }
        return childRouter
    }
    
    public func canHandle<T>(deepLink: DeepLinkOption<T>) -> Bool {
        return false
    }
    
    public func route(url: URL, completion: ((Bool) -> Void)?) {
        
        guard ["http", "https"].contains(url.scheme?.lowercased() ?? "") else { return }
        
        guard let str = url.absoluteString.removingPercentEncoding,
            let combinedUrl = URL(string: str) else {
            present(controller: SFSafariViewController(url: url))
            return
        }
        
        present(controller: SFSafariViewController(url: combinedUrl))
    }
}

extension Routing where Self: UINavigationControllerDelegate {
    
}

public protocol TabRoutable: Routing {
    var tab: Int {get}
}

public class WeakRouter {
    public private(set) weak var router: Routing?
    init(value: Routing?) {
        self.router = value
    }
}

private var childRoutersHandle: UInt8 = 0
private var contextHandle: UInt8 = 1
private var parentHandle: UInt8 = 1
