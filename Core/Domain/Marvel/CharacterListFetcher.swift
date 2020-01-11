//
//  CharactersFetcher.swift
//  Domain
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Additions

public enum CharacterListFilter {
    case all
    case nameStartsWith(String)
    case matching(String)
    case next(result: Entities.CharacterDataWrapper)
}

public protocol CharacterListFetching {
    func fetchCharacters(filter: CharacterListFilter, completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>)->Void)
    func fetchNext(result: Entities.CharacterDataWrapper, completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>)->Void)
    
    func cancel()
}

public protocol CharacterListServiceFactory {
    func makeService() -> SpecialisedDataService
}


public class CharacterListFetcher: CharacterListFetching {
    
    let factory: CharacterListServiceFactory
    let queue = OperationQueue()
    var dispatcher: Dispatching = Dispatcher()
    public init(factory: CharacterListServiceFactory) {
        self.factory = factory
    }
    
    public func fetchCharacters(filter: CharacterListFilter, completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>) -> Void) {

        queue.cancelAllOperations()
        
        var delay: TimeInterval
        switch filter {
        case .matching(_), .nameStartsWith(_):
            delay = 0.5
        default:
            delay = 0.0
        }
        
        let operation = CharacterListFetchOperation(service: factory.makeService(), param: filter, delay: delay, dispatcher: dispatcher, completion: completion)
        queue.addOperation(operation)
    }
    
    public func fetchNext(result: Entities.CharacterDataWrapper, completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>) -> Void) {
        
        let operation = CharacterListFetchOperation(service: factory.makeService(), param: .next(result: result), delay: 0, dispatcher: dispatcher, completion: completion)
        queue.addOperation(operation)
    }
    
    public func cancel() {
        queue.cancelAllOperations()
    }
}

class CharacterListFetchOperation: AsyncOperaiton {
    
    let service: SpecialisedDataService
    let filter: CharacterListFilter
    let delay: TimeInterval?
    let completion: (Result<Entities.CharacterDataWrapper, ServiceError>) -> Void
    let dispatcher: Dispatching
    
    public init(service: SpecialisedDataService, param: CharacterListFilter, delay: TimeInterval, dispatcher: Dispatching, completion: @escaping (Result<Entities.CharacterDataWrapper, ServiceError>) -> Void) {
        self.service = service
        self.filter = param
        self.delay = delay
        self.dispatcher = dispatcher
        self.completion = completion
    }
    
    override func main() {
        super.main()
        
        if let delay = delay {
            Thread.sleep(forTimeInterval: delay)
        }
        
        if isCancelled {
            return
        }
        
        switch filter {
        case .next(result: let result):
            fetchNext(result: result)
        default:
            fetchCharacters(filter: filter)
        }
    }
    
    public func fetchCharacters(filter: CharacterListFilter) {

        var parameters = [String:String]()
        switch filter {
        case .all:
            ()
        case .nameStartsWith(let string):
            parameters["nameStartsWith"] = string
        case .matching(let string):
            parameters["name"] = string
        case .next(result: _):
            dispatch(result: .failure(ServiceError.unknown))
            return
        }
        
        service.getData(parameters: parameters) { [weak self] (result: Result<Entities.CharacterDataWrapper, ServiceError>) in
            self?.dispatch(result: result)
        }
    }
    
    public func fetchNext(result: Entities.CharacterDataWrapper) {
        guard let total = result.data?.total,
            let offset = result.data?.offset,
            let count = result.data?.count
            else { return }
        
        let newOffset: Int = offset + count
        guard total > newOffset else {
            return
        }
        let parameters = ["offset": String(newOffset)]
        service.getData(parameters: parameters) { [weak self] (returnedData: Result<Entities.CharacterDataWrapper, ServiceError>) in
            do {
                let returnedResults = try returnedData.get()
                let characters = result.data?.results ?? []
                let returnedCharacters = returnedResults.data?.results ?? []
                returnedResults.data?.results = characters + returnedCharacters
                self?.dispatch(result: .success(returnedResults))
            } catch {
                self?.dispatch(result: .failure(ServiceError(from: error)))
            }
        }
    }
    
    func dispatch(result: Result<Entities.CharacterDataWrapper, ServiceError>) {
        dispatcher.dispatchMain {
            self.completion(result)
        }
        state = .finished
    }
}
