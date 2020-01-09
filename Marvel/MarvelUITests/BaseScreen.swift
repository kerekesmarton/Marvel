//
//  ConnecttAppUITests
//
//  Copyright © 2018 Connectt. All rights reserved.
//

import XCTest

final class Screen {
    let baseScreen: BaseScreen
    
    init(configuration: TestAppConfiguration) {
        //list of all screens
        baseScreen = BaseScreen(configuration: configuration)
    }
}

class BaseScreen {
    
    static let noTimeoutTime: TimeInterval = 0.0
    static let shortTime: TimeInterval = 0.5
    static let shortTimeout: TimeInterval = 3.0
    static let longTimeout: TimeInterval = 10.0
    
    enum ElementState: String {
        case enabled = "enabled == true"
        case notEnabled = "enabled == false"
        case exists = "exists == true"
        case notExists = "exists == FALSE"
        case hittable = "hittable == true"
        case notHittable = "hittable == false"
    }
    
    enum SwipeDirection {
        case top
        case down
        case left
        case right
    }
    
    private enum ScreenElements: String {
        case activityIndicator
    }
    
    let xcTestCase: XCTestCase!
    
    var tabBar: XCUIElement {
        return app.tabBars.firstMatch
    }
    
    func title(named: String) -> XCUIElement {
        return app.navigationBars[named]
    }
    
    func tabBarItem(tab: AppSteps.Tab) -> XCUIElement {
        return app.tabBars.buttons.element(boundBy: tab.rawValue)
    }
    
    var table: XCUIElement {
        return app.tables.firstMatch
    }
    
    var collection: XCUIElement {
        return app.collectionViews.firstMatch
    }
    
    var searchField: XCUIElement {
        return app.searchFields["Search"]
    }
    
    var keyboard: XCUIElement {
        return app.keyboards.firstMatch
    }
    
    init(configuration: TestAppConfiguration) {
        xcTestCase = configuration.testCase
        app = configuration.app
    }
    
    func loaded() {
        let activitySpinner = app.otherElements.element(matching: .activityIndicator,
                                                          identifier: ScreenElements.activityIndicator.rawValue)
        tryWaitFor(element: activitySpinner, withState: .exists, waiting: BaseScreen.noTimeoutTime)
        tryWaitFor(element: activitySpinner, withState: .notExists)
    }
    
    func waitToTap(element: XCUIElement, runTime: TimeInterval = shortTime,
                   waiting timeout: TimeInterval = longTimeout) {
        waitFor(element: element, withState: .exists, waiting: timeout)
        waitFor(element: element, withState: .hittable, waiting: timeout)
        element.tap()
    }
    
    func waitToForceTap(element: XCUIElement, runTime: TimeInterval = shortTime,
                        waiting timeout: TimeInterval = shortTimeout) {
        waitToBeEnabled(for: element, waiting: timeout)
        element.forceTapElement()
    }
    
    func waitToExist(for element: XCUIElement, waiting timeout: TimeInterval = longTimeout) {
        waitFor(element: element, withState: .exists, waiting: timeout)
    }
    
    func waitToNotExist(for element: XCUIElement, waiting timeout: TimeInterval = longTimeout) {
        waitFor(element: element, withState: .notExists, waiting: timeout)
    }
    
    func waitToBeEnabled(for element: XCUIElement, waiting timeout: TimeInterval = longTimeout) {
        waitToExist(for: element, waiting: timeout)
        waitFor(element: element, withState: .enabled, waiting: timeout)
    }
    
    func waitToNotBeEnabled(for element: XCUIElement, waiting timeout: TimeInterval = longTimeout) {
        waitFor(element: element, withState: .notEnabled, waiting: timeout)
    }
    
    func waitToBeHittable(for element: XCUIElement, waiting timeout: TimeInterval = longTimeout) {
        waitToExist(for: element, waiting: timeout)
        waitFor(element: element, withState: .hittable, waiting: timeout)
    }
    
    func waitToNotBeHittable(for element: XCUIElement, waiting timeout: TimeInterval = longTimeout) {
        waitFor(element: element, withState: .notHittable, waiting: timeout)
    }
    
    func waitForScreenWith(title: String) {
        let navigationBar = app.navigationBars[title]
        waitToBeHittable(for: navigationBar)
    }
    
    func navigateBack() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func quickTap(element: XCUIElement) {
        element.tap()
    }
    
    @discardableResult func tryWaitFor(element: XCUIElement, withState state: ElementState,
                                       waiting timeout: TimeInterval = shortTimeout) -> Bool {
        let predicate = NSPredicate(format: state.rawValue)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let waiterResult = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return waiterResult == .completed
    }
    
    func waitFor(element: XCUIElement, withState state: ElementState,
                 waiting timeout: TimeInterval = longTimeout) {
        XCTAssertTrue(tryWaitFor(element: element, withState: state, waiting: timeout),
                      "Wait for \(element.description) \(state.rawValue) failed with timeout \(timeout)s")
    }
    
    func checkElementExists(element: XCUIElement, runTime: TimeInterval = shortTime) {
        XCTAssertTrue(element.exists, "Check element exists failed")
    }
    
    func elementExists(element: XCUIElement) -> Bool {
        return element.exists
    }
    
    func elementExists(element: XCUIElement, waiting timeout: TimeInterval = shortTime) -> Bool {
        tryWaitFor(element: element, withState: .exists, waiting: timeout)
        return element.exists
    }
    
    func elementCount(_ elements: [XCUIElement], waiting timeout: TimeInterval = shortTime) -> Int {
        let exist: [Bool] = elements.compactMap {
            tryWaitFor(element: $0, withState: .exists, waiting: timeout) ? true : nil
        }
        
        return exist.count
    }
    
    func scroll(list: XCUIElement, cell: XCUIElement, direction: SwipeDirection) {
        while cell.isHittable == false {
            switch direction {
            case .top:
                list.swipeUp()
            case .down:
                list.swipeDown()
            case .left:
                list.swipeLeft()
            case .right:
                list.swipeRight()
            }
        }
    }

    func clearFieldAndEdit(fieldWithContent: String, placeholder: String, value: String) {
        if fieldWithContent.count > 0 {
            let element = app.textFields[fieldWithContent]
            waitToBeHittable(for: element)
            element.buttons["Clear text"].tap()
        }
        
        let emptyField = app.textFields[placeholder]
        waitToBeHittable(for: emptyField)
        emptyField.tap()
        type(value, element: emptyField)
    }
    
    func clearTextView(withPlaceholder placeholder: String?, editWithValue value: String) {
        
        let textView = app.textViews.staticTexts[placeholder ?? ""].firstMatch
        waitToTap(element: textView)
        type(value, element: textView)
        
    }
    
    func clearTextView(withIdentifier identifier: String?, editWithValue value:String) {
        
        let textView = app.textViews.matching(identifier: identifier ?? "").firstMatch
        waitToTap(element: textView)
        type(value, element: textView)
        
    }
    
    func type(_ text: String, element: XCUIElement) {        
        waitFor(element: app.keys.firstMatch, withState: .hittable)
        element.typeText(text)
    }
    
    func scrollToBottom() {
        table.swipeUp()
    }
    
    let app: XCUIApplication
    
    var dev: XCUIDevice {
        return XCUIDevice.shared
    }
    
    /// Returns true if keyboard is visibile and false otherwise
    var isKeyboardVisible: Bool {
        return app.keyboards.firstMatch.exists
    }
    
    /// Returns true if key is visibile and false otherwise
    func isKBKeyVisible(_ key: String) -> Bool {
        return app.keyboards.firstMatch.buttons[key].exists
    }
    
    /// Returns true if there are any alerts visibile and false otherwise
    var alertExists: Bool {
        return app.alerts.allElementsBoundByIndex.count > 0
    }
    /// Returns Alert by titlte if there are any alerts visibile and nil otherwise
    func alert(with title: String) -> XCUIElement {
        return findByAccessibility(.alert, acIdentifier: title).firstMatch
    }
    
    /// Function used to find all elements by type
    ///
    /// - Parameter type:  XCUIElement.ElementType represents type of element (button, view, etc.)
    /// - Returns: XCUIElementQuery with found elements
    func findAll(_ type: XCUIElement.ElementType) -> XCUIElementQuery {
        return app.descendants(matching: type)
    }
    
    /// Function used to find all elements by type and accessibility string
    ///
    /// - Parameters:
    ///   - type:  XCUIElement.ElementType represents tyope of element (button, view, etc.)
    ///   - acIdentifier: accessibility identifier as string
    /// - Returns: XCUIElementQuery with found elements
    func findByAccessibility(_ type: XCUIElement.ElementType, acIdentifier: String) -> XCUIElement {
        return findAll(type).matching(identifier: acIdentifier).firstMatch
    }
    
    func getElementCount(_ type: XCUIElement.ElementType) -> Int {
        return app.descendants(matching: type).count
    }
    
    func firstCell(of type: XCUIElement.ElementType, named: String) -> XCUIElement {
        let cell = app.cells.containing(type, identifier: named).firstMatch
        return cell
    }
    
    func element(with staticText: String) -> XCUIElement {
        let element = app.staticTexts[staticText].firstMatch
        waitToExist(for: element)
        return element
    }
    
    func button(with text: String) -> XCUIElement {
        let button = app.buttons[text].firstMatch
        waitToExist(for: button)
        return button
    }
    
    func checkEmptyState(string: String) {
        waitToExist(for: app.tables.firstMatch)
        let label = app.tables.firstMatch.label
        XCTAssertTrue(label.contains(string))
    }
    
    func tapEmptyStateButton(named: String) {
        waitToExist(for: app.tables.firstMatch)
        let button = app.tables.firstMatch.buttons.firstMatch
        XCTAssertTrue(button.label.contains(named))
        
        button.tap()
    }
    
    func swipeOnCell(title assetName: String, ofType type: XCUIElement.ElementType) {
        waitToBeHittable(for: table)
        table.cells.containing(type, identifier: assetName).element(boundBy: 0).swipeLeft()
    }
    
}
