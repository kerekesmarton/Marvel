//  Copyright © 2018 Connectt. All rights reserved.

import XCTest
@testable import Domain
@testable import Presentation
@testable import Data
@testable import CoreTestHelpers

class BaseFeature: XCTestCase {
    
    lazy var app: XCUIApplication! = {
        return  XCUIApplication()
    }()
    lazy var configuration: TestAppConfiguration! = TestAppConfiguration(app: app, testCase: self)
    
    lazy var appSteps = AppSteps(configuration: configuration)
    lazy var characterListSteps = CharacterListSteps(configuration: configuration)
    lazy var characterSteps = CharacterSteps(configuration: configuration)
    lazy var seriesListSteps = SeriesListSteps(configuration: configuration)
    
    lazy var featureFlags = FeatureFlags(uploadVideo: false, searchTabs: false, mention: false)
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        do {
            try configureEnvironmentLaunchArguments(for: app)
        } catch {
            guard let e = ServiceError(from: error).message else { return }
            fatalError(e)
        }
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    lazy var requests = [String: [RequestResponsePair]]()
    var notification: [String: Any]?
    
    private func addInterruptionMonitor() {
        addUIInterruptionMonitor(withDescription: description) { element -> Bool in
            do {
                // Push Notification
                let button = element.buttons["Allow"]
                let title = element.staticTexts["“ConnecttApp” Would Like to Send You Notifications"]
                if title.exists && button.exists {
                    button.tap()
                }
            }
            return true
        }
        app.tap()
    }
}

// MARK: Environment Launch Arguments
extension BaseFeature {
    
    fileprivate func configureEnvironmentLaunchArguments(for app: XCUIApplication) throws {
        
        try requests.forEach({ (requestVariation) in
            let data = try JSONEncoder().encode(requestVariation.value)
            
            let encodedKey = requestVariation.key.replacingOccurrences(of: "=", with: "+")
            app.launchEnvironment[encodedKey] = data.base64EncodedString()
        })
        
        if let notification = notification {
            do {
                let data = try JSONSerialization.data(withJSONObject: notification)
                if let dataString = String(data: data, encoding: .utf8) {
                    app.launchEnvironment[UIApplication.LaunchOptionsKey.remoteNotification.rawValue] = dataString
                }
            } catch let error {
               print(error)
            }
        }
        
        app.launchEnvironment["ts"] = UUID().uuidString
        app.launchEnvironment["publicKey"] = "public"
        app.launchEnvironment["privateKey"] = "private"
        app.launchEnvironment["isTesting"] = "true"
        app.launchEnvironment["NoAnimations"] = "true"
        
    }
}

struct ProcessKeyConstants {
    static let moduleIdentifier = "moduleIdentifier"
    static let responseData = "responseData"
    static let requestData = "requestData"
}
