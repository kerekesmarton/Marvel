//
//  PresentationTests
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import XCTest
@testable import Presentation
@testable import Domain
@testable import MarvelAuth
@testable import IosCore
@testable import CoreTestHelpers

final class LoginPresenterTests: XCTestCase {
    
    private var loginPresenter: LoginPresenter!
    private var mockedView: MockLoginView!
    private var mockedRouter: MockLoginRouter!
    private var mockConfig: MockConfig = MockConfig.shared
    
    
    override func setUp() {
        super.setUp()
        
        mockedRouter = MockLoginRouter()
        mockedView = MockLoginView()
        
        loginPresenter = LoginPresenter(userRepository: MockUserProfileStore(),
                                        router: mockedRouter, config: mockConfig)
        loginPresenter.view = mockedView
    }
    
    func test_GivenDidLogin_WhenSuccess_ThenSuccessLoginSuccessDisplayed() {
        loginPresenter.viewReady()
        
        XCTAssertEqual(mockedView.spyState, .disabled)
        mockedView.inputPublicAction?("Test")
        mockedView.inputPrivateAction?("Test")
        XCTAssertEqual(mockedView.spyState, .enabled)
        loginPresenter.save()
        XCTAssertTrue(mockedRouter.spyFinish)
    }
    
}

final class MockLoginView: NSObject, LoginPresentingOutput {
    var inputPublicAction: Edit?
    
    var inputPrivateAction: Edit?
    
    var spyState: PresentationOutputState?
    var state: PresentationOutputState? {
        didSet {
            spyState = state
        }
    }
}

final class MockLoginRouter: MockErrorRouting, LoginRouting {
    func start() {}
    
    var parent: Routing?
    
    func present(controller: UIViewController) {}
    
    var spyFinish = false
    func finish() {
        spyFinish = true
    }
    
    func routeToForgotPassword() {}
    func routeToSignUp() {}
}
