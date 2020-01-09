//
//  CharacterListSteps.swift
//  MarvelUITests
//
//  Created by Marton Kerekes on 09/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import XCTest
@testable import Domain

class CharacterListSteps: BaseSteps {
    
    lazy var characterListScreen = BaseScreen(configuration: configuration)
    
    func verify(character: Entities.Character) {
        
        guard var text = character.name else {
            XCTFail()
            return
        }
        
        if let desc = character.description {
            text += " " + desc
        }
        
        let cell = characterListScreen.firstCell(of: .staticText, named: text)
        characterListScreen.waitToExist(for: cell)
    }
}
