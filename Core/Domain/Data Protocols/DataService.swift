//
//  Domain
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public protocol GenericDataService {
    func getData<T>(fetchResult: @escaping (T?, ServiceError?)-> Void)
}

public protocol SpecialisedDataService: GenericDataService {
    
    func getData<T>(from: URL, completion: @escaping (T?, ServiceError?) -> Void)
    func getData<T>(from: URL, parameters: [String: String], completion: @escaping (T?, ServiceError?) -> Void)
    func getData<T>(parameters: [String], completion: @escaping (T?, ServiceError?) -> Void)
    func getData<T>(parameters: [String: String], completion: @escaping (T?, ServiceError?) -> Void)
    func getData<T, U>(payload: U?, completion: @escaping (T?, ServiceError?) -> Void)
    func getData<T, U>(parameters: [String], payload: U?, completion: @escaping (T?, ServiceError?) -> Void)
    func getData<T, U>(parameters: [String: String], payload: U?, completion: @escaping (T?, ServiceError?) -> Void)
    
    func upload<T, U>(data: Data, parameters: [String : String], payload: U, completion: @escaping (T?, ServiceError?) -> Void)
    
    func subscribeToCache<T>(changes: @escaping (T?, ServiceError?)-> Void)
    func subscribeToCache<T>(with parameters: [String: String], changes: @escaping (T?, ServiceError?)-> Void)
    func fetchCache<T>(parameters: [String : String], update: @escaping (T?, ServiceError?) -> Void)
    func fetchCacheList<T>(parameters: [String : String], update: @escaping (T?, ServiceError?) -> Void)
    
    /// Used to save an entity to cache through the service's access to DataPersistence
    ///
    /// - Parameters:
    ///   - payload: the item to be saved.
    ///   - parameters: if this is a list, pass in an empty [:], otherwise the parameters you used to create/update the object with.
    func saveCache<T>(payload: T, parameters: [String : String], completion: @escaping (ServiceError?) -> Void)
    
    func deleteCache(completion: @escaping (ServiceError?) -> Void)
}

public struct ErrorEntity {
    public let message: String
    public init(message: String) {
        self.message = message
    }
}


public enum ServiceError: Error {
    case parsing(String)
    case network(Error?)
    case server(HTTPURLResponse, Error?)
    case client(HTTPURLResponse?, Error?)
    case message(String)
    case unknown
    
    public var message: String? {
        switch self {
        case .parsing(let message):
            return message
        case .network(_):
            return "human_readable_error_check_network_connection".localised
        case .server(let response, _):
            return response.status?.userReadableText
        case .client(let response, _):
            return response?.status?.userReadableText
        case .message(let response):
            return response
        case .unknown:
            return "human_readable_error_unknown".localised
        }
    }
    
    public var title: String? {
        return nil
    }
    
    public init?(from error: Error, response: HTTPURLResponse? = nil) {
        switch error {
        case is DecodingError:
            switch error as! DecodingError {
            case .typeMismatch(let type, let context):
                self = .parsing(context.debugDescription + " on " + String(describing:type))
            case .valueNotFound(let type, let context):
                self = .parsing(context.debugDescription + " on " + String(describing:type))
            case .keyNotFound(let codingKey, let context):
                self = .parsing(context.debugDescription + " on " + codingKey.stringValue)
            case .dataCorrupted(let context):
                self = .parsing(context.debugDescription)
            default:
                self = .parsing(error.localizedDescription)
            }
        case is ServiceError:
            self = error as! ServiceError
        default:
            if let response = response, let serviceError = ServiceError(from: response) {
                self = serviceError
            } else {
                let nserror = error as NSError
                switch nserror.domain {
                case "NSURLErrorDomain":
                    self = ServiceError.network(error)
                default:
                    self = ServiceError.unknown
                }
            }            
        }
    }
    
    public init?(from response: HTTPURLResponse, error: Error? = nil) {
        guard let status = HTTPStatusCode(rawValue: response.statusCode) else {
            return nil
        }
        switch status.responseType {
        case .clientError:
            self = ServiceError.client(response, error)
        case .serverError:
            self = ServiceError.server(response, error)
        default:
            self = ServiceError.unknown
        }
    }
    
    public init(from error: ErrorEntity) {
        self = ServiceError.message(error.message)
    }
}

extension ServiceError: Equatable {}

public func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
    switch (lhs, rhs) {
    case (.parsing(let error1), .parsing(let error2)):
        return error1 == error2
    case (.network(_), .network(_)):
        return true
    case (.server(let response1, _), .server(let response2, _)):
        return (response1 == response2)
    case (.client(let response1, _), .client(let response2, _)):
        return response1 == response2
    default:
        return false
    }
}
