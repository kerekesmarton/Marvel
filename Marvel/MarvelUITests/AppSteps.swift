//
//  ConnecttAppUITests
//
//  Copyright © 2018 Connectt. All rights reserved.
//

import XCTest

class AppSteps: BaseSteps {
    
    var appScreen: BaseScreen {
        return screen.baseScreen
    }
    
    var app: XCUIApplication {
        return appScreen.app
    }
    
    // MARK: - Tabs
    enum Tab: Int {
        case characters
        case series
    }
    
    func goTo(tab: Tab) {
        let button = appScreen.tabBarItem(tab: tab)
        appScreen.waitToBeHittable(for: button)
        button.tap()
    }
}
