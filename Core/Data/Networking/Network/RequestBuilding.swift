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
    func hash(with ts: String) -> String?
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
    init(store: UserProfileStoring, config: SettingsConfigurable, crypto: Encryptable) {
        self.store = store
        self.settings = config
        self.crypto = crypto
    }
    
    func hash(with ts: String) -> String? {
        guard let publicKey = store.publicKey else { return nil }
        guard let privateKey = store.privateKey else { return nil }
        return crypto.md5Hex(from: ts + privateKey + publicKey)
    }
    
    func appendAuthParameters(to url: URL) throws -> URL {
        /*
         ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150
         */
        let ts = UUID().uuidString
        let tsQueryItem = URLQueryItem(name: "ts", value: ts)
        let apiKey = store.publicKey
        let apiKeyQueryItem = URLQueryItem(name: "apiKey", value: apiKey)
        let hashValue = hash(with: ts)
        let hashQueryItem = URLQueryItem(name: "hash", value: hashValue)
        return try add(queryItems: [tsQueryItem,apiKeyQueryItem,hashQueryItem], to: url)
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
