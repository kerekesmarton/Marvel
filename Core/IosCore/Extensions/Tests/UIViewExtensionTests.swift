///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import XCTest
@testable import IosCore

class UIViewExtensionTests: XCTestCase {

    func test_GivenView_WhenConstrainedToItsSuperview_ThenCheckConstraints(){
        
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        
        let childView = UIView()
        parentView.addSubview(childView)
        childView.constraintToSuperviewEdges()
        
        XCTAssertEqual(childView.translatesAutoresizingMaskIntoConstraints, false)
        XCTAssert(parentView.constraints.filter({ $0.firstAnchor == childView.topAnchor }).first != nil)
        XCTAssert(parentView.constraints.filter({ $0.firstAnchor == childView.leadingAnchor }).first != nil)
        XCTAssert(parentView.constraints.filter({ $0.firstAnchor == childView.bottomAnchor }).first != nil)
        XCTAssert(parentView.constraints.filter({ $0.firstAnchor == childView.trailingAnchor }).first != nil)
        
    }
  
}
