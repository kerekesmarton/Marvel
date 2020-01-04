//
//  CharactersFetcher.swift
//  Domain
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation

public protocol CharactersFetchering {
    func fetchCharacters(completion: (Result<Entities.CharacterDataWrapper, ServiceError>)->Void)
}

public class CharactersFetcherer: CharactersFetchering {
    
    let service: SpecialisedDataService
    public init(service: SpecialisedDataService) {
        self.service = service
    }
    
    public func fetchCharacters(completion: (Result<Entities.CharacterDataWrapper, ServiceError>) -> Void) {
        
    }
}

