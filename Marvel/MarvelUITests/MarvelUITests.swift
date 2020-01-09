//
//  MarvelUITests.swift
//  MarvelUITests
//
//  Created by Marton Kerekes on 09/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import XCTest
import Domain

class CharacterListUITests: BaseFeature {

    lazy var character = Entities.johnAppleseed
    lazy var characterList = Entities.characters([character])
        
    //data source for character list
    var characterListPair: RequestResponsePair {
        return try! RequestResponsePair(response: characterList)
    }
                
    override func setUp() {
        requests["/v1/public/characters"] = [characterListPair]
        
        super.setUp()
    }
    
    func testGivenListOfCharacter_WhenAppLaunched_ListReturned() {
        
        characterListSteps.verify(character: character)
    }
}
