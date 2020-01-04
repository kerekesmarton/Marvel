//
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import XCTest
@testable import IosCore
@testable import Presentation
@testable import Domain

class AppRouterTests: XCTestCase {
    let mockedWelcome: MockLoginModule = MockLoginModule()
    
    func test_GivenWindow_WhenStartingApp_ThenTabsLaunched() {
        
        let window = UIWindow()
        let mockedStyle = MockStyle()
        let appRouter = AppRouter(window: window, style: mockedStyle)
        appRouter.start()
        
        XCTAssertTrue(mockedStyle.spySetup)
    }
    
    func test_GivenAppLoaded_WhenSetupModules_ThenTabsLaunched() {
        let window = UIWindow()
        let mockedStyle = MockStyle()
        let appRouter = AppRouter(window: window, style: mockedStyle)
        
        let feed = NavigationConfiguration.Item(title: "", icon: "Tab-Home", moduleName: "network")
        let explore = NavigationConfiguration.Item(title: "", icon: "Tab-Explore", moduleName: "channels")
        let post = NavigationConfiguration.Item(title: "", icon: "Tab-Create-Post", moduleName: "settings")
        let profile = NavigationConfiguration.Item(title: "", icon: "Tab-Profile", moduleName: "profile")
        let navigationConfig = NavigationConfiguration(modules: [feed, explore, post, profile])
        
        _ = appRouter.setupModules(navConfig: navigationConfig)
        
        XCTAssertTrue(window.rootViewController is TabBarController)        
    }
    
    func test_GivenAppRequiresWelcom_ThenWelcomeStarted() {
        let window = UIWindow()
        let mockedStyle = MockStyle()
        let appRouter = AppRouter(window: window, style: mockedStyle)
        appRouter.config.appModules.add(mockedWelcome)
        appRouter.setupWelcomeScreen()
        
        XCTAssertEqual(window.rootViewController, mockedWelcome.stubViewController)
        XCTAssertTrue(appRouter.childRouters!.contains(where: { (weakRef) -> Bool in
            return weakRef.router === mockedWelcome.stubRouting
        }))
    }
}

class MockLoginModule: Module, LoginModulable {
    let stubViewController = UIViewController()
    let stubRouting = MockRouting()
    func setup(config: Configurable, didFinishAuth: @escaping UserDidFinishAuth) -> (controller: UIViewController, router: Routing) {
        return (stubViewController, stubRouting)
    }
}

class MockRouting: Routing {
    func start() {
    }
}

class MockStyle: StyleProviding {
    var navigation: NavigationStyleProvider?
    
    var tabBar: TabBarStyle?
    
    var controls: ControlsProvider?
    
    var cells: CellsProvider?
    
    var list: TableStyle?
    
    var spySetup = false
    func setup() {
        spySetup = true
    }
}
