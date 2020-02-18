//
//  CharacterListPresenterTests.swift
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
@testable import MarvelDomain

class CharacterListPresenterTests: XCTestCase {

    var mockFetcher: MockCharacterListFetching!
    var mockRouter: MockCharacterListRouting!
    var presenter: CharacterListPresenter!
    var mockOutput: MockCharacterListPresentationOutput!
    
    override func setUp() {
        mockFetcher = MockCharacterListFetching()
        mockRouter = MockCharacterListRouting()
        mockOutput = MockCharacterListPresentationOutput()
        mockOutput = MockCharacterListPresentationOutput()
        presenter = CharacterListPresenter(charecterListFetcher: mockFetcher, router: mockRouter)
        presenter.output = mockOutput
    }

    override func tearDown() {
        mockFetcher = nil
        mockRouter = nil
        presenter = nil
        
    }

    func testGivenViewAppears_WhenCharactersFetched_ThenCharactersDisplayed() {
        
        let john = Entities.johnAppleseed
        let results = Entities.characters([john])
        
        mockFetcher.stubResponse = .success(results)
        
        presenter.viewReady()
        
        XCTAssertTrue(mockOutput.spyReload)
    }
    
    func testGivenViewAppears_WhenCharactersFetchReturnsError_ThenErrorShown() {
        
        mockFetcher.stubResponse = .failure(ServiceError.unknown)
        
        presenter.viewReady()
        
        XCTAssertEqual(mockRouter.spyServiceError, ServiceError.unknown)
    }
    
    func testGivenCharactersLoaded_WhenDisplaying_InterfacePopulated() {
        
        let john = Entities.johnAppleseed
        let results = Entities.characters([john])
        
        mockFetcher.stubResponse = .success(results)
        
        presenter.viewReady()
        
        XCTAssertEqual(presenter.itemCount, 1)
        
        let mockItem = MockCharacterPresentingItem()
        presenter.setup(cell: mockItem, at: 0)
        
        XCTAssertEqual(mockItem.spyInfo?.name.string, "John Appleseed This is John")
        XCTAssertEqual(mockItem.spyTitle, "This is John")
        XCTAssertEqual(mockItem.spyUrl, URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/5/a0/570bde5514b01/portrait_uncanny.jpg"))
    }
    
    func testGivenCharactersDisplayed_WhenTapped_CharacterDetailsShown() {
        
        let john = Entities.johnAppleseed
        let results = Entities.characters([john])
        
        mockFetcher.stubResponse = .success(results)
        
        presenter.viewReady()

        let mockItem = MockCharacterPresentingItem()
        presenter.didSelect(cell: mockItem, at: 0)
        XCTAssertEqual(mockRouter.spyCharacter, john)
    }
}

final class MockCharacterPresentingItem: CharacterPresentingItem {
    
    var spyInfo: PresentableInfo?
    var spyTitle: String?
    var spyUrl: URL?
    func setup(info: PresentableInfo, title: String?, imageURL: URL?, type: ListType) {
        spyInfo = info
        spyTitle = title
        spyUrl = imageURL
    }
}

final class MockCharacterListFetching: CharacterListFetching {
    
    var stubResponse: Result<Entities.CharacterDataWrapper, ServiceError>!
    func fetchCharacters(filter: CharacterListFilter, completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>) -> Void) {
        completion(stubResponse)
    }
    
    var spyResult: Entities.CharacterDataWrapper?
    func fetchNext(result: Entities.CharacterDataWrapper, completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>) -> Void) {
        spyResult = result
        completion(stubResponse)
    }
    
    func cancel() {
        
    }
}

final class MockCharacterListRouting: MockErrorRouting, CharacterListRouting {
    
    var spyCharacter: Entities.Character?
    func route(character: Entities.Character) {
        spyCharacter = character
    }
}

final class MockCharacterListPresentationOutput: MockFontCalculating, CharacterListPresentationOutput {
    
    var spyReload = false
    func reload() {
        spyReload = true
    }
    

}

class MockFontCalculating: UIViewController, Styleable, FontCalculating {
    
    func applyStyle(){}
    
    func getFont(for style: FontStyle) -> UIFont {
        return UIFont.systemFont(ofSize: 12)
    }
    
    func getColor(for style: FontStyle) -> UIColor {
        return .black
    }
}
