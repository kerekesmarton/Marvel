//
//  Data
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Additions

public class NetworkDataServiceFactory {}

class NetworkDataService: SpecialisedDataService {
    
    let session: Sessionable
    var requestBuilder: RequestBuilding
    let dataParser: DataParsing
    let dataEncoder: DataEncoding?
    let dataPersistence: DataPersisting?
    var dispatcher: Dispatching = Dispatcher()
    
    init(requestBuilder: RequestBuilding, dataParser: DataParsing, dataEncoder: DataEncoding?, session:Sessionable, dataPersistence: DataPersisting? = nil) {
        self.requestBuilder = requestBuilder
        self.dataParser = dataParser
        self.session = session
        self.dataPersistence = dataPersistence
        self.dataEncoder = dataEncoder
    }
    
    func getData<T>(from url: URL, parameters: [String : String], completion: @escaping (Result<T, ServiceError>) -> Void) {
        do {
            let request = try requestBuilder.request(with: parameters)
            sendData(with: request, completion: completion)
        } catch ServiceError.parsing(let string){
            completion(.failure(ServiceError.parsing(string)))
        } catch {
            completion(.failure(ServiceError.parsing(error.localizedDescription)))
        }
    }
    
    public func getData<T>(from url: URL, completion: @escaping (Result<T, ServiceError>) -> Void) {
        do {
            let request = try requestBuilder.request()
            sendData(with: request, completion: completion)
        } catch ServiceError.parsing(let string){
            completion(.failure(ServiceError.parsing(string)))
        } catch {
            completion(.failure(ServiceError.parsing(error.localizedDescription)))
        }
    }
    
    public func getData<T>(fetchResult completion: @escaping (Result<T, ServiceError>) -> Void) {
        do {
            let request = try requestBuilder.request()
            fetchFromPersistence(request, [:], completion)
            sendData(with: request, completion: completion)
        } catch {
            completion(.failure(ServiceError(from: error)))
        }
    }
    
    func getData<T>(parameters: [String], completion: @escaping (Result<T, ServiceError>) -> Void) {
        do {
            let request = try requestBuilder.request(with: parameters)
            sendData(with: request, completion: completion)
        } catch {
            completion(.failure(ServiceError(from: error)))
        }
    }
    
    public func getData<T>(parameters: [String : String], completion: @escaping (Result<T, ServiceError>) -> Void) {
        do {
            let request = try requestBuilder.request(with: parameters)
            fetchFromPersistence(request, parameters, completion)
            sendData(with: request, completion: completion)
        } catch {
            completion(.failure(ServiceError(from: error)))
        }
    }
    
    func getData<T, U>(parameters: [String], payload: U?, completion: @escaping (Result<T, ServiceError>) -> Void) {
        guard let payload = payload, let dataEncoder = dataEncoder else {
            getData(fetchResult: completion)
            return
        }
        encode(dataEncoder, payload, completion: completion)
    }
    
    func getData<T, U>(payload: U?, completion: @escaping (Result<T, ServiceError>) -> Void) {
        guard let payload = payload, let dataEncoder = dataEncoder else {
            getData(fetchResult: completion)
            return
        }
        encode(dataEncoder, payload, completion: completion)
    }
    
    func getData<T, U>(parameters: [String : String], payload: U?, completion: @escaping (Result<T, ServiceError>) -> Void) {
        guard let payload = payload, let dataEncoder = dataEncoder else {
            getData(parameters: parameters, completion: completion)
            return
        }
        encode(dataEncoder, payload, parameters, completion: completion)
    }
    
    func upload<T, U>(data: Data, parameters: [String : String], payload: U, completion: @escaping (Result<T, ServiceError>) -> Void) {
        
        do {
            guard let metaData = try dataEncoder?.parse(from: payload) else {
                completion(.failure(ServiceError.unknown))
                return
            }
            _upload(data: data, parameters: parameters, metaData: metaData, completion: completion)
        }
        catch {
            completion(.failure(ServiceError(from: error)))
        }
        
    }
    
    func _upload<T>(data: Data, parameters: [String : String], metaData: Data, completion: @escaping (Result<T, ServiceError>) -> Void) {
        
        do {

            let boundary = UUID().uuidString

            let uploadData = requestBuilder.prepareforFormUpload(image: data, meta: metaData, boundary: boundary)
            requestBuilder.httpBody = uploadData
            let request = try requestBuilder.formRequest(with: parameters, boundary: boundary)

            session.uploadTask(with: request, from: uploadData, completionHandler: { [weak self] data, response, error in
                guard let response = response as? HTTPURLResponse else {
                    self?.dispatch(results: nil, error: error ?? ServiceError.network(error), completion)
                    return
                }
                guard response.statusCode < 400 else {
                    self?.parseFailedResponse(data: data, response: response, completion: completion)
                    return
                }
                self?.parseSuccessResponse(data: data, response: response, completion: completion)
            }).resume()

        }
        catch {
            completion(.failure(ServiceError(from: error)))
        }
        
    }
    
    public func subscribeToCache<T>(changes: @escaping (Result<T, ServiceError>) -> Void) {
        subscribeToCache(with: [:], changes: changes)
    }
    
    func subscribeToCache<T>(with parameters: [String : String], changes: @escaping (Result<T, ServiceError>) -> Void) {
        let request = try? requestBuilder.request(with: parameters) //on updates we don't want to push persistent request errors
        let persistenceRequest = requestBuilder.persistenceRequest(parameters: parameters)
        if persistenceRequest.count > 0 {
            dataPersistence?.notifyChanges(with: persistenceRequest, fetchResult: changes)
        } else if let id = request?.url?.absoluteString {
            dataPersistence?.notifyChanges(with: ["id":id], fetchResult: changes)
        } else {
            dataPersistence?.notifyChanges(with: [:], fetchResult: changes)
        }
    }
    
    public func fetchCache<T>(parameters: [String : String], update: @escaping (Result<T, ServiceError>) -> Void) {
        let persistenceRequest = requestBuilder.persistenceRequest(parameters: parameters)
        guard persistenceRequest.count > 0 else {
            return
        }
        guard let result: T = dataPersistence?.fetch(with: persistenceRequest) else {
            return
        }
        update(.success(result))
        
    }
    
    func fetchCacheList<T>(parameters: [String : String], update: @escaping (Result<T, ServiceError>) -> Void) {
        do {
            let request = try requestBuilder.request(with: parameters)
            guard let id = request.url?.absoluteString else {
                return
            }
            guard let result: T = dataPersistence?.fetch(with: ["id": id]) else {
                return
            }
            update(.success(result))
        } catch {
            update(.failure(ServiceError(from: error)))
        }
    }
    
    public func saveCache<T>(payload: T, parameters: [String : String], completion: @escaping (ServiceError?) -> Void) {
        dispatcher.dispatch(queue: DispatchQueue.global()) { [weak self] in
            self?._saveCache(payload: payload, parameters: parameters, completion: completion)
        }
    }
    
    private func _saveCache<T>(payload: T, parameters: [String : String], completion: @escaping (ServiceError?) -> Void) {
        do {
            guard let data = try dataEncoder?.encode(from: payload) else {
                return
            }
            let request = try requestBuilder.request(with: parameters)
            let persistenceRequest = requestBuilder.persistenceRequest(parameters: parameters)
            if persistenceRequest.count > 0 {
                let _: T? = try dataParser.parse(data)
                dispatcher.dispatchMain {
                    completion(nil)
                }
            } else if let id = request.url?.absoluteString, let url = URL(string: id) {
                let _: T? = try dataParser.parse(data, source: url)
                dispatcher.dispatchMain {
                    completion(nil)
                }
            } else {
                let _: T? = try dataParser.parse(data)
                dispatcher.dispatchMain {
                    completion(nil)
                }
            }
        } catch {
            dispatcher.dispatchMain {
                completion(ServiceError(from: error))
            }            
        }
    }
    
    public func deleteCache(completion: @escaping (ServiceError?) -> Void) {
        dataPersistence?.deleteAll(deleteResult: completion)
    }
}

extension NetworkDataService {
    
    private func encode<T, U>(_ dataEncoder: DataEncoding, _ payload: U, completion: @escaping (Result<T, ServiceError>) -> Void) {
        do {
            let data = try dataEncoder.parse(from: payload)
            attachAndSend(data: data, error: nil, completion: completion)
        } catch {
            attachAndSend(data: nil, error: ServiceError(from: error), completion: completion)
        }
    }
    
    private func encode<T, U>(_ dataEncoder: DataEncoding, _ payload: U, _ parameters: [String : String], completion: @escaping (Result<T, ServiceError>) -> Void) {
        do {
            let data = try dataEncoder.parse(from: payload)
            attachAndSend(parameters: parameters, data: data, error: nil, completion: completion)
        } catch {
            attachAndSend(parameters: parameters, data: nil, error: ServiceError(from: error), completion: completion)
        }
    }
    
    private func attachAndSend<T>(data: Data?, error: ServiceError?, completion: @escaping (Result<T, ServiceError>) -> Void) {
        if let data = data {
            requestBuilder.httpBody = data
            getData(fetchResult: completion)
        } else if let error = error {
            completion(.failure(error))
        }
    }
    
    private func attachAndSend<T>(parameters: [String: String], data: Data?, error: ServiceError?, completion: @escaping (Result<T, ServiceError>) -> Void) {
        if let data = data {
            requestBuilder.httpBody = data
            getData(parameters: parameters, completion: completion)
        } else if let error = error {
            completion(.failure(error))
        }
    }
    
    private func dispatch<T>(results: T?, error: Error?, _ completion: @escaping (Result<T, ServiceError>) -> Void) {
        dispatcher.dispatchMain {
            if let results = results {
                completion(.success(results))
            } else if let error = error {
                completion(.failure(ServiceError(from: error)))
            } else {
                completion(.failure(ServiceError.unknown))
            }
        }
    }
    
    private func dispatch<T>(error: ServiceError?, completion: @escaping (Result<T, ServiceError>) -> Void) {
        dispatcher.dispatchMain {
            if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    private func parseSuccessResponse<T>(data: Data?, response: HTTPURLResponse, completion: @escaping (Result<T, ServiceError>) -> Void) {
        guard let data = data else {
            dispatch(results: nil, error: nil, completion)
            return
        }
        do {
            let results: T? = try dataParser.parse(data, source: response.url)
            dispatch(results: results, error: nil, completion)
        } catch {
            dispatch(error: ServiceError(from: error), completion: completion)
        }
    }
    
    private func parseFailedResponse<T>(data: Data?, response: HTTPURLResponse, completion: @escaping (Result<T, ServiceError>) -> Void) {
        guard let data = data, data.count > 0, response.statusCode < 500 else {
            dispatch(error: ServiceError(from: response), completion: completion)
            return
        }
        do {
            let _: T? = try dataParser.parse(data)
        } catch {
            dispatch(error: ServiceError(from: error, response: response), completion: completion)
        }
    }
    
    private func sendData<T>(with request: URLRequest, completion: @escaping (Result<T, ServiceError>) -> Void) {
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                self?.dispatch(results: nil, error: error ?? ServiceError.network(error), completion)
                return
            }
            guard response.statusCode < 400 else {
                self?.parseFailedResponse(data: data, response: response, completion: completion)
                return
            }
            self?.parseSuccessResponse(data: data, response: response, completion: completion)
        }
        task.resume()
    }
    
    private func fetchFromPersistence<T>(_ request: URLRequest, _ params: [String: String], _ completion: @escaping (Result<T, ServiceError>) -> Void) {
        guard requestBuilder.method == .get else {
            return
        }
        
        let persistenceRequest = requestBuilder.persistenceRequest(parameters: params)
        if persistenceRequest.count > 0 {
            dataPersistence?.fetch(with: persistenceRequest, fetchResult: completion)
        } else if let url = request.url?.stringRemovingAuthParams() {
            dataPersistence?.fetch(with: ["id":url], fetchResult: completion)
        } else {
            dataPersistence?.fetch(with: [:], fetchResult: completion)
        }
    }
}
