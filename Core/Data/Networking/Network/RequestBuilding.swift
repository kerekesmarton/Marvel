//
//  Data
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
    case put = "PUT"
}

protocol RequestBuilding: class {
    var uri: URL { get set }
    var httpBody: Data? { get set }
    var method: HTTPMethod? { get set }
    var token: String? { get }    
    var cachePolicy: URLRequest.CachePolicy? { get }
    var parameters: [String:String] { get set }
    
    func request() throws -> URLRequest
    func createUrl() throws -> URL
    func preprocess(parameters: inout [String: String]) -> [String: String]
    func persistenceRequest(parameters: [String: String]) -> [String:String]
}

public class BaseRequestBuilder {
    lazy public var uri: URL = baseUrl
    public var httpBody: Data?
    public var method: HTTPMethod?
    public var token: String?
    public let baseUrl: URL
    public var parameters = [String:String]()
    func createUrl() throws -> URL {
        return uri
    }
    public init(config: SettingsConfigurable) {
        baseUrl = URL(string: config.environment.rawValue)!
    }
}

extension RequestBuilding {
    
    private func decorated(_ requestToDecorate: URLRequest) -> URLRequest {
        var request = requestToDecorate
        if let body = httpBody {
            request.httpBody = body
        }
        if let contentType = contentTypeKey {
            request.setValue(contentType, forHTTPHeaderField: contentTypeFieldKey)
            request.setValue(contentType, forHTTPHeaderField: acceptKey)
        }
        request.setValue(userAgent, forHTTPHeaderField: userAgentKey)
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let method = method {
            request.httpMethod = method.rawValue
        }
        if let cachePolicy = cachePolicy {
            request.cachePolicy = cachePolicy
        }
        
        return request
    }
    
    func request() throws -> URLRequest {
        return try decorated(URLRequest(url: createUrl()))
    }
    
    func request(with parameters: [String:String]) throws -> URLRequest {
        var params = parameters
        self.parameters = preprocess(parameters: &params)
        guard self.parameters.count > 0 else {
            return try self.request()
        }
        let components = try URLComponents(url: createUrl(), resolvingAgainstBaseURL: false)!
        let request = URLRequest(url: components.url!)
        return decorated(request)
    }
    
    func preprocess(parameters: inout [String : String]) -> [String : String] {
        return parameters
    }
    
    func request(with parameters: [String]) throws -> URLRequest {
        var uri = try createUrl()
        parameters.forEach { (component) in
            uri = uri.appendingPathComponent(component)
        }        
        let request = URLRequest(url: uri)
        return decorated(request)
    }
    
    func add(queryItems: [URLQueryItem], to url: URL) throws -> URL {
        guard !queryItems.isEmpty else {
            return url
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw ServiceError.parsing("could not generate request")
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw ServiceError.parsing("could not generate request")
        }
        
        return url
    }
    
    var contentTypeFieldKey: String {
        return "Content-Type"
    }
    
    var userAgentKey: String {
        return "User-Agent"
    }
    
    var userAgent: String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "ios"
        }
        return "ios" + "_v\(appVersion)"
    }
    
    var acceptKey: String {
        return "accept"
    }
    
    var contentTypeKey: String? {
        return "application/json"
    }
    
    var cachePolicy: URLRequest.CachePolicy? {
         return nil
    }
    
    func prepareforFormUpload(image data: Data, meta: Data, boundary: String) -> Data {
        var uploadData = Data()
        
        uploadData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        // Add the field and its value to the raw http request data        
        uploadData.append("Content-Disposition: form-data; name=\"metadata\"\r\n".data(using: .utf8)!)
        uploadData.append("\r\n".data(using: .utf8)! + meta + "\r\n".data(using: .utf8)!)
        
        // Add the image data to the raw http request data
        uploadData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"media\"; filename=\"blob\"\r\n".data(using: .utf8)!)
        uploadData.append("Content-Type: application/octet-stream\r\n".data(using: .utf8)!)
        uploadData.append("\r\n".data(using: .utf8)! + data)
        
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        uploadData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return uploadData
    }
    
    func formRequest(with parameters: [String:String], boundary: String) throws -> URLRequest {
        var params = parameters
        self.parameters = preprocess(parameters: &params)
        
        var request: URLRequest
        if self.parameters.count > 0 {
            var components = try URLComponents(url: createUrl(), resolvingAgainstBaseURL: false)!
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            request = URLRequest(url: components.url!)
        } else {
            request = try self.request()
        }
        
        if let contentType = contentTypeKey {
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: contentTypeFieldKey)
            request.setValue(contentType, forHTTPHeaderField: acceptKey)
        }
        
        return request
    }
    
    func persistenceRequest(parameters: [String: String]) -> [String:String] {
        return [:]
    }
    
}
