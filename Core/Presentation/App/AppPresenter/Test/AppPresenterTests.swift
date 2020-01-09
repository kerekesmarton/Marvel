//
//  PresentationTests
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import XCTest
@testable import Presentation
@testable import Domain
@testable import CoreTestHelpers

class AppPresenterTests: XCTestCase {
    
    var mockedConfig: MockConfig!
    var mockedRouter: MockAppRouter!
    var mockedNotificationServices: MockNotificationServices!
    var appPresenter: AppPresenter!
    var mockedInteractor: MockAppSessionInteractor!
    var mockedSettingsConfig: MockSettingsConfigurable!
    var mockUserProfileStore: MockUserProfileStore!
    
    override func setUp() {
        super.setUp()
        
        mockedConfig = MockConfig.shared
        mockedInteractor = MockAppSessionInteractor()
        mockedRouter = MockAppRouter()
        mockedRouter.stubOutput = MockAppPresentingOutput()
        mockedNotificationServices = MockNotificationServices()
        mockedSettingsConfig = MockSettingsConfigurable(defaults: MockDefaultSettings())
        mockUserProfileStore = MockUserProfileStore(defaults: MockDefaultSettings())
        
        appPresenter = AppPresenter(router: mockedRouter,
                                    config: mockedConfig,
                                    interactor: mockedInteractor,
                                    settingsInteractor: mockedSettingsConfig,
                                    notifications: mockedNotificationServices,
                                    userRepository: mockUserProfileStore)
    }
    
    override func tearDown() {
        mockedConfig = nil
        mockedRouter = nil
        mockedNotificationServices = nil
        appPresenter = nil
        mockedInteractor = nil
        
        super.tearDown()
    }
    
    func test_GivenAppStarting_WhenAppLoaded_ThenModulesPreseted() {
        
        mockedInteractor.stubUserLoggedIn = true
        mockedConfig.spyDidFinish?()
        appPresenter.loadApplication()
        
        XCTAssertEqual(mockedConfig.spyLoadConfiguration, 1)
        XCTAssertTrue(mockedRouter.spySetupModules)
        XCTAssertTrue(mockedRouter.spyStart)
    }
    
    func test_GivenSignupRequired_WhenAppLoaded_ThenModulesPresented() {
        mockedConfig.sessionRequired = true
        mockedConfig.spyDidFinish?()
        appPresenter.loadApplication()
        
        XCTAssert(mockedNotificationServices.spyPresenter as! AppPresenter === appPresenter)
        XCTAssertTrue(mockedRouter.spySetupSession)
    }
    
    func test_GivenSignupRequired_AndTokenPresent_WhenAppLoaded_ThenModulesPresented() {
        mockedConfig.sessionRequired = true
        mockedInteractor.stubUserLoggedIn = true
        mockedConfig.spyDidFinish?()
        appPresenter.loadApplication()
        
        XCTAssertTrue(mockedRouter.spySetupModules)
    }
    
    func test_GivenDeepLink_AndTokenPresent_WhenAppLoaded_ThenLinkLoaded() {
        mockedInteractor.stubUserLoggedIn = true
        appPresenter.link(with: DeepLinkOption<URL>.payload(URL(string: "www.google.com")!))
        
        XCTAssertNotNil(mockedRouter.spyDeepLink)
    }
    
    func testGivenTokenExpired_WhenRefeshSuccess_AppRefreshes() {
        mockedInteractor.stubRefreshNeeded = true
        mockedInteractor.stubSuccess = true
        mockedInteractor.stubUserLoggedIn = true
        appPresenter.loadApplication()
        
//        XCTAssertTrue(mockedInteractor.didRefresh)
        XCTAssertTrue(mockedRouter.spySetupModules)
    }
    
    func testGivenTokenExpired_WhenRefeshFailed_AppRefreshes() {
        mockedInteractor.stubRefreshNeeded = true
        mockedInteractor.stubSuccess = false
        appPresenter.loadApplication()
        
//        XCTAssertTrue(mockedInteractor.didRefresh)
        XCTAssertTrue(mockedRouter.spySetupSession)
    }
    
}

class MockAppSessionInteractor: AppSessionable {
    
    var stubSuccess = true
    var didRefresh = false
    func refreshSession(completion: @escaping (Bool, ServiceError?) -> Void) {
        didRefresh = true
        completion(stubSuccess, nil)
    }
    
    var stubRefreshNeeded = false
    func refreshNeeded() -> Bool {
        let value = stubRefreshNeeded
        stubRefreshNeeded = !value //this is needed so we don't end up in an infinite loop during tests
        return value
    }
    
    func refreshNeededForResume() -> Bool {
        return false
    }
    
    var stubUserLoggedIn = false
    func userIsLoggedIn() -> Bool {
        return stubUserLoggedIn
    }
    
    func logoutUser() {
        
    }
}

class MockKeyChain: KeychainLoading {
    var id: String?
    
    var stubValue: String?
    
    var token: String? {
        return stubValue
    }
    func saveToken(_ value: String) {
        stubValue = value
    }
}

class MockAppRouter: AppRouting {
    var spySetupModules = false
    var stubOutput: MockAppPresentingOutput!
    func setupModules(navConfig: NavigationConfiguration) -> TabbedPresenentationOutput {
        spySetupModules = true
        return stubOutput
    }
    
    var spySetupSession = false
    func setupWelcomeScreen() {
        spySetupSession = true
    }
    
    
    var spyStart = false
    func start() {
        spyStart = true
    }
    
    var spyDeepLink: DeepLinkOption<URL>?
    func route<T>(deepLink: DeepLinkOption<T>) {
        spyDeepLink = (deepLink as? DeepLinkOption<URL>)
    }
    
    func route(tab: AppRoutableTabs) {}
    
    func setupLoadingScreen() {}
}

class MockAppPresentingOutput: TabbedPresenentationOutput {
    func redDotOnNotificationsTab() {}
    
    func updateNotificationsTabBadge(value: Int) {}
    
    func show(message: InAppMessage, completion: DisplayInAppMessageResultBlock?) {
    }
}

class MockNotificationServices: NotificationServices {
    func requestAccess() {}
    
    var spyPresenter: AppPresenting?
    func launch(with presenter: AppPresenting) {
        spyPresenter = presenter
    }
}
