//
//  ConnecttAppUITests
//
//  Copyright © 2018 Connectt. All rights reserved.
//

import XCTest
@testable import Domain

final class TestAppConfiguration {
    let app: XCUIApplication
    let testCase: XCTestCase
    
    init(app: XCUIApplication, testCase: XCTestCase) {
        self.app = app
        self.testCase = testCase
    }
}

class BaseSteps {
    
    let screen: Screen
    let configuration: TestAppConfiguration
    
    init(configuration: TestAppConfiguration) {
        self.screen = Screen(configuration: configuration)
        self.configuration = configuration
    }
    
    func scrollToBottom() {
        screen.baseScreen.scrollToBottom()
    }
    
    func tapLastCell() {
        let totalCells = screen.baseScreen.table.cells.count
        screen.baseScreen.table.cells.element(boundBy: (totalCells - 1)).tap()
    }
    
    func tapLastCell(with tableView: XCUIElement) {
        let totalCells = tableView.cells.count
        let lastCell = tableView.cells.element(boundBy: (totalCells - 1))
        lastCell.tap()
    }
    
    func tapReturnKeyType(for element: XCUIElement, name: String) {
        screen.baseScreen.waitToExist(for: element)
        element.tap()
        configuration.app.keyboards.buttons[name].tap()
    }
    
    func verifyTextFieldIsFocusable(for element: XCUIElement) {
        screen.baseScreen.waitToExist(for: element)
        XCTAssertTrue(element.hasFocus())
    }
    
    func verifyExistance(for element: XCUIElement, assertFalse: Bool = false) {
        if !assertFalse{
            XCTAssertTrue(screen.baseScreen.elementExists(element: element))
        }
        else{
            XCTAssertFalse(screen.baseScreen.elementExists(element: element))
        }
    }
    
    func populateTextField(element: XCUIElement, with text: String) {
        screen.baseScreen.waitToExist(for: element)
        element.tap()
        element.typeText(text)
    }
    
    func assertEnabled(for element: XCUIElement, assertFalse: Bool = false) {
        
        if !assertFalse {
            XCTAssertTrue(element.isEnabled)
        }
        else {
            XCTAssertFalse(element.isEnabled)
        }
        
    }
    
    /// Returns true if keyboard is visibile and false otherwise
    var isKeyboardVisible: Bool {
        return screen.baseScreen.keyboard.exists
    }
    
}
