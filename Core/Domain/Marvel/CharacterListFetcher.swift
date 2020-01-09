//
//  CharactersFetcher.swift
//  Domain
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation

public protocol CharacterListFetching {
    func fetchCharacters(completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>)->Void)
    func fetchNext(result: Entities.CharacterDataWrapper, completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>)->Void)
}

public class CharacterListFetcher: CharacterListFetching {
    
    let service: SpecialisedDataService
    public init(service: SpecialisedDataService) {
        self.service = service
    }
    
    public func fetchCharacters(completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>) -> Void) {
        let parameters = [String:String]()
        service.getData(parameters: parameters) { (result: Result<Entities.CharacterDataWrapper, ServiceError>) in
            completion(result)
        }
    }
    
    public func fetchNext(result: Entities.CharacterDataWrapper, completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>) -> Void) {        
        guard let total = result.data?.total,
            let offset = result.data?.offset,
            let count = result.data?.count
            else { return }
        
        let newOffset: Int = offset + count
        guard total > newOffset else {
            return
        }
        let parameters = ["offset": String(newOffset)]
        service.getData(parameters: parameters) { (returnedData: Result<Entities.CharacterDataWrapper, ServiceError>) in
            do {
                let returnedResults = try returnedData.get()
                let characters = result.data?.results ?? []
                let returnedCharacters = returnedResults.data?.results ?? []
                returnedResults.data?.results = characters + returnedCharacters
                completion(.success(returnedResults))
            } catch {
                completion(.failure(ServiceError(from: error)))
            }
            
            completion(returnedData)
        }
    }
}

