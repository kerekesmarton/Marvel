//
//  CharacterListViewControllerTests.swift
//  MarvelCharactersTests
//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import XCTest
@testable import MarvelCharacters
@testable import Domain
@testable import Presentation
@testable import IosCore


class CharacterListViewControllerTests: XCTestCase {

    var viewController: CharacterListViewController!
    var mockPresenter:MockCharacterListPresenting!
    override func setUp() {
        viewController = CharacterListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        mockPresenter = MockCharacterListPresenting()
        viewController.presenter = mockPresenter
    }

    override func tearDown() {
        viewController = nil
        mockPresenter = nil
    }

    func testGivenLoaded_ThenPresenterNotified() {
        viewController.viewDidLoad()
        XCTAssertTrue(mockPresenter.spyViewReady)
    }
    
    func testGivenViewAppears_PresenterDoesNotLoad() {
        
        viewController.viewWillAppear(true)
        viewController.viewDidAppear(true)
        
        XCTAssertFalse(mockPresenter.spyViewReady)
    }
    
    func testGivenReloading_CellsPopulated() {
        XCTAssertEqual(viewController.collectionView(viewController.collectionView, numberOfItemsInSection: 0), 0)
        mockPresenter.stubitemCount = 1
        XCTAssertEqual(viewController.collectionView(viewController.collectionView, numberOfItemsInSection: 0), 1)
        
        
        let cell = viewController.collectionView(viewController.collectionView, cellForItemAt: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(mockPresenter.spyCell, cell)
    }
    
    func testGivenCellTapped_CharacterDisplayed() {
        XCTAssertEqual(viewController.collectionView(viewController.collectionView, numberOfItemsInSection: 0), 0)
        mockPresenter.stubitemCount = 1
        XCTAssertEqual(viewController.collectionView(viewController.collectionView, numberOfItemsInSection: 0), 1)
        
        let ip: IndexPath = IndexPath(row: 0, section: 0)
        let cell = ProfileCollectionViewCell()
        let mockCollectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        mockCollectionView.stubCell = cell
        viewController.collectionView(mockCollectionView, didSelectItemAt: ip)
        
        XCTAssertEqual(mockPresenter.spyCell, cell)
    }
}

class MockCollectionView: UICollectionView {
    
    var stubCell: UICollectionViewCell?
    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        return stubCell
    }
}

class MockCharacterListPresenting: CharacterListPresenting {
    
    var spyViewReady = false
    func viewReady() {
        spyViewReady = true
    }
    
    func viewDidReachEnd() {
        
    }
    
    var stubitemCount = 0
    var itemCount: Int {
        return stubitemCount
    }
    
    var spyCell: ProfileCollectionViewCell?
    func setup(cell: CharacterPresentingItem, at index: Int) {
        spyCell = cell as? ProfileCollectionViewCell
    }
    
    func didSelect(cell: CharacterPresentingItem, at index: Int) {
        spyCell = cell as? ProfileCollectionViewCell
    }
    
    func didTapEmptyStateButton() {
        
    }
    
    var emptyStateTitle: NSAttributedString {
        return NSAttributedString()
    }
    
    var emptyStateTitleDetail: NSAttributedString? {
           return NSAttributedString()
       }
    
    var emptyStateButtonTitle: String? {
           return ""
       }
    
    var emptyStateShouldShow: Bool {
           return false
    }
}
