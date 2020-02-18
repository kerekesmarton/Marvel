///
//  ConnecttApp
//
//  Copyright © 2019 Connectt. All rights reserved.
//

import Foundation
@testable import Data
@testable import Domain
@testable import MarvelData

class RequestResponsePair: Codable {
    var request: String? = nil
    var response: String? = nil
    
    init<Request, Response>(request: Request, response: Response) throws {
        guard let requestData = try GenericDataEncoder().encode(from: request) else {
            throw ServiceError.parsing("couldn't parse data \(request)")
        }
        
        guard let responseData = try GenericDataEncoder().encode(from: response) else {
            throw ServiceError.parsing("couldn't parse data \(response)")
        }
        
        self.request = requestData.base64EncodedString()
        self.response = responseData.base64EncodedString()
    }
    
    init<Response>(response: Response) throws {
        
        guard let responseData = try GenericDataEncoder().encode(from: response) else {
            throw ServiceError.parsing("couldn't parse data \(response)")
        }
        
        self.response = responseData.base64EncodedString()
    }
    
    init() {}
    
//    func adding<Request, Response>(request: Request, response: Response) throws -> RequestResponsePair {
//        isConfigured = true
//
//        guard let requestData = try GenericDataEncoder().encode(from: request) else {
//                throw ServiceError.client("incorrect setup", nil)
//        }
//
//        guard let responseData = try GenericDataEncoder().encode(from: response) else {
//            throw ServiceError.client("incorrect setup", nil)
//        }
//        UserDefaults.standard.set(requestData, forKey: <#T##String#>)
//        return self
//    }
//
//    func adding<Response>(response: Response) throws -> RequestResponsePair {
//        isConfigured = true
//        guard let data = try GenericDataEncoder().encode(from: response) else {
//                throw ServiceError.client("incorrect setup", nil)
//        }
//
//        return try write(data: data, to: fileName)
//    }
//
//    private func write(data: Data, to file: String) throws -> RequestResponsePair {
//        let file = try path(for: file, ofType: .json)
//
//        try data.write(to: file)
//        return self
//    }
//
//    enum ResourceType: String {
//        case json
//        case jpeg
//    }
//
//    private func path(for resource: String, ofType type: ResourceType) throws -> URL {
//        guard let filePath = Bundle(for: RequestResponsePair.self).url(forResource: resource, withExtension: type.rawValue) else {
//            throw ServiceError.parsing("File not found")
//        }
//        return filePath
//    }
}
