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

public protocol Encryptable {
    func md5Data(from string: String) -> Data
    func md5Hex(from string: String) -> String
    func md5Base64(from string: String) -> String
}

protocol RequestBuilding: class {
    var uri: URL { get set }
    var httpBody: Data? { get set }
    var method: HTTPMethod? { get set }
    var cachePolicy: URLRequest.CachePolicy? { get }
    var parameters: [String:String] { get set }
    
    /// Implemented by extension, do not override.
    func request() throws -> URLRequest
    
    /// NetworkDataService asks for the url using the RequestBuilder. Populate fields using `preprocess` frist.
    func createUrl() throws -> URL
    
    /// NetworkDataService gives an opportunity for the Request Builder to populate it's required fields, if any.
    /// - Parameter parameters: Populate this with the required id, keyd by the field name.
    func preprocess(parameters: inout [String: String]) -> [String: String]
    
    /// pass parameters to fetch apropriate data model for persistence.
    /// - Parameter parameters: Populate this with the required id, keyd by the field name.
    func persistenceRequest(parameters: [String: String]) -> [String:String]
}

public class BaseRequestBuilder {
    var httpBody: Data?
    var method: HTTPMethod? = HTTPMethod(rawValue: "GET")
    var parameters = [String:String]()
    lazy var uri: URL = {
        return settings.environment.baseUrl
    }()
    private let store: UserProfileStoring
    private let settings: SettingsConfigurable
    private let crypto: Encryptable
    private let uniqueStringProvider: UniqueStringProviding
    public init(store: UserProfileStoring, config: SettingsConfigurable, crypto: Encryptable, uniqueStringProviding: UniqueStringProviding) {
        self.store = store
        self.settings = config
        self.crypto = crypto
        self.uniqueStringProvider = uniqueStringProviding
    }
    
    private func makeAuthParameters() -> [URLQueryItem] {
        let ts = uniqueStringProvider.uniqueString
        let tsQueryItem = URLQueryItem(name: "ts", value: ts)
        let apiKeyQueryItem = URLQueryItem(name: "apikey", value: store.publicKey)
        let hashQueryItem = URLQueryItem(name: "hash", value: hash(with: ts))
        return [tsQueryItem, apiKeyQueryItem, hashQueryItem]
    }
    
    private func hash(with ts: String) -> String? {
        guard let publicKey = store.publicKey else { return nil }
        guard let privateKey = store.privateKey else { return nil }
        return crypto.md5Hex(from: ts + privateKey + publicKey)
    }
    
    func makeQueryItems() -> [URLQueryItem] {
        var queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems.append(contentsOf: makeAuthParameters())
        return queryItems
    }
}

extension RequestBuilding {
    
    private func decorated(url: URL) throws -> URLRequest {
        var request: URLRequest = URLRequest(url: url)
        if let body = httpBody {
            request.httpBody = body
        }
        if let contentType = contentTypeKey {
            request.setValue(contentType, forHTTPHeaderField: contentTypeFieldKey)
            request.setValue(contentType, forHTTPHeaderField: acceptKey)
        }
        request.setValue(userAgent, forHTTPHeaderField: userAgentKey)
        if let method = method {
            request.httpMethod = method.rawValue
        }
        if let cachePolicy = cachePolicy {
            request.cachePolicy = cachePolicy
        }
        
        return request
    }
    
    func request() throws -> URLRequest {
        return try decorated(url: createUrl())
    }
    
    func request(with parameters: [String:String]) throws -> URLRequest {
        var params = parameters
        self.parameters = preprocess(parameters: &params)
        guard self.parameters.count > 0 else {
            return try self.request()
        }
        let components = try URLComponents(url: createUrl(), resolvingAgainstBaseURL: false)
        guard let url = components?.url else { throw ServiceError.parsing("request cannot be made with params \(parameters)") }
        return try decorated(url: url)
    }
    
    func preprocess(parameters: inout [String : String]) -> [String : String] {
        return parameters
    }
    
    func request(with parameters: [String]) throws -> URLRequest {
        var url = try createUrl()
        parameters.forEach { (component) in
            url = url.appendingPathComponent(component)
        }        
        return try decorated(url: url)
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

extension URL {
    func add(queryItems: [URLQueryItem]) throws -> URL {
        guard !queryItems.isEmpty else {
            return self
        }
        
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw ServiceError.parsing("could not generate request")
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw ServiceError.parsing("could not generate request")
        }
        
        return url
    }
}
