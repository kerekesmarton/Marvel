//
//  ConnecttAppUITests
//
//  Copyright © 2018 Connectt. All rights reserved.
//

import XCTest

extension XCUIElement {
    
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
    
    func clearAndEnter(text: String) {
        guard let currentString = self.value as? String else {
            XCTFail("Failed as XCUIElement not text field")
            return
        }
        let deleteString = currentString.map { _ in XCUIKeyboardKey.delete.rawValue }.joined(separator: "")
        self.typeText(deleteString)
        self.typeText(text)
    }
    
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
    
    func longtap() {
        press(forDuration: 1.2)
    }
    
    func hasFocus() -> Bool {
        let hasKeyboardFocus = (self.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
        return hasKeyboardFocus
    }
    
}
