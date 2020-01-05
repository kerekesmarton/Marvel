//
//  CharacterListPresenter.swift
//  Characters
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation

protocol CharacterListPresenting {
    func viewReady()
}

protocol CharacterListPresentationOutput: class {
    func reload()
}

protocol CharacterListRouting {
    
}

class CharacterListPresenter: CharacterListPresenting {
    
    weak var output: CharacterListPresentationOutput!
    let router: CharacterListRouting
    
    func viewReady() {
        output.reload()
    }
    
    init(router: CharacterListRouting) {
        self.router = router
    }
}
