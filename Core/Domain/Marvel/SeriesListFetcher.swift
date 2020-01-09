//
//  StoryListFetcher.swift
//  Domain
//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation

public enum SeriesListType {
    case all
    case character(Entities.Character)
}

public protocol SeriesListFetching {
    func fetchStories(type: SeriesListType, completion: @escaping (Result<Entities.SeriesDataWrapper, ServiceError>)->Void)
    func fetchNext(result: Entities.SeriesDataWrapper, completion: @escaping (Result<Entities.SeriesDataWrapper, ServiceError>)->Void)
}

public class SeriesListFetcher: SeriesListFetching {
    
    let service: SpecialisedDataService
    public init(service: SpecialisedDataService) {
        self.service = service
    }
    
    public func fetchStories(type: SeriesListType, completion: @escaping (Result<Entities.SeriesDataWrapper, ServiceError>) -> Void) {
        
        let parameters = [String:String]()
        switch type {
        case .all:
            service.getData(parameters: parameters) { (result: Result<Entities.SeriesDataWrapper, ServiceError>) in
                completion(result)
            }
        case .character(let character):
            guard let uri = character.stories?.collectionURI, let url = URL(string: uri) else { return }
            service.getData(from: url, parameters: parameters) { (result: Result<Entities.SeriesDataWrapper, ServiceError>) in
                completion(result)
            }
        }
    }
    
    public func fetchNext(result: Entities.SeriesDataWrapper, completion: @escaping (Result<Entities.SeriesDataWrapper, ServiceError>) -> Void) {
        guard let total = result.data?.total,
            let offset = result.data?.offset,
            let count = result.data?.count
            else { return }
        
        let newOffset: Int = offset + count
        guard total > newOffset else {
            return
        }
        let parameters = ["offset": String(newOffset)]
        service.getData(parameters: parameters) { (returnedData: Result<Entities.SeriesDataWrapper, ServiceError>) in
            do {
                let returnedResults = try returnedData.get()
                let stories = result.data?.results ?? []
                let returnedStories = returnedResults.data?.results ?? []
                returnedResults.data?.results = stories + returnedStories
                completion(.success(returnedResults))
            } catch {
                completion(.failure(ServiceError(from: error)))
            }
            
            completion(returnedData)
        }
    }
    
}

