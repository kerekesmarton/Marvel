//
//  CharacterListFetcherTests.swift
//  DomainTests
//
//  Created by Marton Kerekes on 11/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import XCTest
@testable import Domain
@testable import Additions

class CharacterListFetcherTests: XCTestCase {
    
    var mockedService: MockDataService<Entities.CharacterDataWrapper, Void>!
    var mockedSearchFactory: MockCharacterListFetcherServiceFactory!
    var fetcher: CharacterListFetcher!
    var result: Entities.Character!
    
    override func setUp() {
        mockedService = MockDataService<Entities.CharacterDataWrapper, Void>()
        mockedSearchFactory = MockCharacterListFetcherServiceFactory(service: mockedService)
        fetcher = CharacterListFetcher(factory: mockedSearchFactory)
        fetcher.dispatcher = MockDispatcher()
        result = Entities.johnAppleseed
    }
    
    func testSearchReturnsDelayed() {
        mockedService.stubResponse = Entities.characters([result])
        
        var capturedResult: Entities.CharacterDataWrapper?
        fetcher.fetchCharacters(filter: .nameStartsWith("john")) { (result) in
            capturedResult = try! result.get()
        }
        
        XCTAssertNil(capturedResult)
    }
    
    func testSearchReturnsResults() {
        mockedService.stubResponse = Entities.characters([result])
        
        let exp = expectation(description: "delay")
        var capturedResult: Entities.CharacterDataWrapper?
        fetcher.fetchCharacters(filter: .nameStartsWith("john")) { (result) in
            capturedResult = try! result.get()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: TimeInterval(floatLiteral: 100))
        XCTAssertNotNil(capturedResult)
    }
    
    func testSearchReturnsOnceForThreeConsecutiveRequests() {
        
        mockedService.stubResponse = Entities.characters([result])
        
        var capturedResult1: Entities.CharacterDataWrapper?
        var capturedResult2: Entities.CharacterDataWrapper?
        var capturedResult3: Entities.CharacterDataWrapper?
        let exp = expectation(description: "delay3")
        fetcher.fetchCharacters(filter: .nameStartsWith("john")) { (result) in
            capturedResult1 = try! result.get()
            exp.fulfill()
        }
        
        fetcher.fetchCharacters(filter: .nameStartsWith("john2")) { (result) in
            capturedResult2 = try! result.get()
            exp.fulfill()
        }
        
        fetcher.fetchCharacters(filter: .nameStartsWith("john3")) { (result) in
            capturedResult3 = try! result.get()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: TimeInterval(floatLiteral: 100))
        XCTAssertNil(capturedResult1)
        XCTAssertNil(capturedResult2)
        XCTAssertNotNil(capturedResult3)
    }
    
}

class MockCharacterListFetcherServiceFactory: CharacterListServiceFactory {
    
    let service: SpecialisedDataService
    init(service: SpecialisedDataService) {
        self.service = service
    }
    
    func makeService() -> SpecialisedDataService {
        return service
    }
}

