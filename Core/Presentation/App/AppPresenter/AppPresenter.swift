//
//  Presentation
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Additions

public protocol NotificationServices {
    func launch(with presenter: AppPresenting)
    func requestAccess()
}

public struct NavigationConfiguration {
    
    public var items: [Item]
    
    public struct Item: Equatable {
        public let titleRes: String
        public let iconRes: String
        public let moduleName: String
        
        public init(title: String, icon: String, moduleName: String) {
            self.titleRes = title
            self.iconRes = icon
            self.moduleName = moduleName
        }
        
        public static func ==(lhs: Item, rhs: Item) -> Bool {
            guard lhs.moduleName == rhs.moduleName
                else { return false }
            return true
        }
    }
    
    public init(modules: [Item]) {
        self.items = modules
    }
    
}

public typealias DisplayInAppMessageResultBlock = (DisplayInAppMessageCompletion) -> Void
public enum DisplayInAppMessageCompletion {
    case timeOut
    case dismiss
    case messageIntaraction
    case buttonInteraction(String)
}

public protocol AppPresenting: class {
    var output: TabbedPresenentationOutput? { get set }
    func loadApplication()
    func applicationWillEnterForeground()
    func link<T>(with deepLink: DeepLinkOption<T>?)
    func displayInApp(message: InAppMessage, completion: DisplayInAppMessageResultBlock?)
    func showRedDotOnNotificationsTab()
}

public enum AppRoutableTabs: Int {
    case feed
    case explore
    case createPost
    case notifications
    case profile
}

public protocol AppRouting {
    func start()
    func setupModules(navConfig: NavigationConfiguration) -> TabbedPresenentationOutput
    func setupWelcomeScreen()
    func setupLoadingScreen()
    func route<T>(deepLink: DeepLinkOption<T>)
    func route(tab: AppRoutableTabs)
}

public protocol AppRoutingDelegate: class {
    func didLogin()
    func displayInApp(message: InAppMessage, completion: DisplayInAppMessageResultBlock?)
    func createPost()
    func setNeedsRestart()
    func deepLink<T>(with link: DeepLinkOption<T>)
}

public protocol AppPresentingOutput: class {
    func show(message: InAppMessage, completion:  DisplayInAppMessageResultBlock?)
}

public protocol TabbedPresenentationOutput: AppPresentingOutput {
    func updateNotificationsTabBadge(value: Int)
    func redDotOnNotificationsTab()
}

public class AppPresenter: AppPresenting {
    
    //MARK: - Properties
    let router: AppRouting
    var config: Configurable
    let sessionInteractor: AppSessionable
    var userRepository: UserProfileStoring
    let settingsInteractor: SettingsConfigurable
    let notifications: NotificationServices
    var dispatcher: Dispatching = Dispatcher()
    
    private var sessionRequired: Bool {
        return true
    }
    
    //MARK: - Constructor
    public init(router: AppRouting,
                config: Configurable,
                interactor: AppSessionable,
                settingsInteractor: SettingsConfigurable,
                notifications: NotificationServices,
                userRepository: UserProfileStoring) {
        
        self.router = router
        self.config = config
        self.sessionInteractor = interactor
        self.settingsInteractor = settingsInteractor
        self.notifications = notifications
        self.userRepository = userRepository
    }
    
    //MARK: - AppPresenting
    weak public var output: (AppPresentingOutput & TabbedPresenentationOutput)?
    
    public func loadApplication() {
        router.start()
        config.loadConfiguration {
            self._loadApplication()
        }
    }
    
    public func applicationWillEnterForeground() {
//        guard sessionInteractor.refreshNeededForResume() else {
//            refreshChatToken()
//            return
//        }
//        sessionInteractor.refreshSession { [weak self] (success, error) in
//            if success {
//                self?.refreshChatToken()
//            } else {
//                self?.router.setupWelcomeScreen()
//            }
//        }
    }
    
    public func link<T>(with deepLink: DeepLinkOption<T>?) {
        guard let deepLink = deepLink else { return }
        config.addToLoad { [weak self] in
            self?._link(with: deepLink)
            }
    }

    public func showRedDotOnNotificationsTab() {
        output?.redDotOnNotificationsTab()
    }
    
    //MARK: - Private methods
    private func setupNavigationConfig() {
        let feed = NavigationConfiguration.Item(title: "", icon: "Tab-Home", moduleName: "network")
        let explore = NavigationConfiguration.Item(title: "", icon: "Tab-Explore", moduleName: "explore")
        let post = NavigationConfiguration.Item(title: "", icon: "Tab-Create-Post", moduleName: "create-post")
        let notification = NavigationConfiguration.Item(title: "", icon: "Tab-Notification", moduleName: "notifications")
        let profile = NavigationConfiguration.Item(title: "", icon: "Tab-Profile", moduleName: "profile")
        navigationConfig = NavigationConfiguration(modules: [feed, explore, post, notification, profile])
    }
    
    private func _loadApplication() {
        
        if navigationConfig == nil {
            setupNavigationConfig()
        }
        
//        if sessionInteractor.refreshNeeded() {
//            sessionInteractor.refreshSession { [weak self] (success, error) in
//                if success {
//                    self?._loadApplication()
//                }
//                else {
//                    self?.router.setupWelcomeScreen()
//                }
//            }
//            return
//        }
        
        notifications.launch(with: self)
        defferredLoading()
    }
    
    private var navigationConfig: NavigationConfiguration? = nil
        
    private func _link<T>(with deepLink: DeepLinkOption<T>) {
        guard sessionInteractor.userIsLoggedIn() || !sessionRequired else { return }
        router.route(deepLink: deepLink)
    }
    
    private func _displayInApp(message: InAppMessage, completion: ((DisplayInAppMessageCompletion) -> Void)?) {
        guard sessionInteractor.userIsLoggedIn() || !sessionRequired else { return }
        output?.show(message: message, completion: completion)
    }
    
    private func defferredLoading() {
        if TestHelper.shouldShowWelcome {
            router.setupWelcomeScreen()
        }
        else {
            if sessionRequired, !sessionInteractor.userIsLoggedIn() {
                router.setupWelcomeScreen()
            } else {
                output = router.setupModules(navConfig: navigationConfig!)
            }
        }
    }
    
}

extension AppPresenter: AppRoutingDelegate {
    public func didLogin() {
        defferredLoading()
    }
    
    public func displayInApp(message: InAppMessage, completion: ((DisplayInAppMessageCompletion) -> Void)?) {
        if message.isDeepLink {
            config.addToLoad { [weak self] in
                self?._displayInApp(message: message, completion: completion)
            }
        } else {
            output?.show(message: message, completion: completion)
        }
    }
    
    public func createPost() {
        router.route(tab: .createPost)
    }
    
    public func setNeedsRestart() {
        defferredLoading()
    }
    
    public func deepLink<T>(with link: DeepLinkOption<T>) {
        router.route(deepLink: link)
    }
}

extension AppPresenter: SettingsConfigurableDelegate {
    public func settingsDidChange() {
        router.setupWelcomeScreen()
    }
}
