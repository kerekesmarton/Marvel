//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain

class MockURLSession: Sessionable {
    static var shared =  MockURLSession.init()
    
    private struct RequestResponsePair: Codable {
        let requestData: String?
        let responseData: String?
    }
    
    private struct StoredRequestResponsePair {
        var request: Data? = nil
        var response: Data? = nil
        init() {}
    }
    
    private var storedData = [String: [StoredRequestResponsePair]]()
    
    private init(){        
        ProcessInfo().environment.forEach { (query, value) in
            let q = query.replacingOccurrences(of: "+", with: "=")
            guard q.hasPrefix("/") else {
                return
            }
            
            guard let data = Data(base64Encoded: value) else {
                return
            }
            
            let requestResponsePairs = try! JSONDecoder().decode([[String: String]].self, from: data)
            
            requestResponsePairs.forEach({ (pair) in
                var storedPair = StoredRequestResponsePair()
                if let encoded = pair["request"],
                    let data = Data(base64Encoded: encoded) {                    
                    storedPair.request = data
                }
                
                if let encoded = pair["response"],
                    let data = Data(base64Encoded: encoded) {
                    
                    storedPair.response = data
                }
                let query = Environment.dev.baseUrl.absoluteString + q
                var stored = storedData[query] ?? []
                stored.append(storedPair)
                storedData[query] = stored
            })
        }
    }
    
    private func findInfoForNonNilRequest(_ storedInfo: [MockURLSession.StoredRequestResponsePair], _ request: URLRequest) -> Int? {
        guard let data = request.httpBody else { return nil }
        return storedInfo.firstIndex { (pair) -> Bool in
            guard let requestData = pair.request else { return false }
            return comparable(requestData) == comparable(data)
        }
    }
    
    func comparable(_ data: Data) -> [String:AnyHashable] {
        return try! JSONSerialization.jsonObject(with: data) as! [String:AnyHashable]
    }
    
    private func findInfoForNilRequest(_ storedInfo: [MockURLSession.StoredRequestResponsePair], _ request: URLRequest) -> Int? {
        guard request.httpBody == nil else {
            return nil
        }
        return storedInfo.firstIndex { (pair) -> Bool in
            pair.request == nil
        }
    }
    
    func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {        
        completionHandler(nil, successResponse(url: request.url!), nil)
        return StubUploadTask()
    }
    
    private func dispatchSuccess(_ pair: MockURLSession.StoredRequestResponsePair, _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void, _ request: URLRequest) {
        DispatchQueue.global().async {
            completionHandler(pair.response, self.successResponse(url: request.url!), nil)
        }
    }
    
    private func dispatchFailure(_ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void, _ request: URLRequest) {
        DispatchQueue.global().async {
            completionHandler(nil, self.failedResponse(url: request.url!), nil)
        }
    }
    
    private func handleImageFetch(_ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void, _ request: URLRequest) {
        if let q = request.url,
            ( q.absoluteString.starts(with: "https://images.unsplash.com") ||
                q.absoluteString.starts(with: "https://avatar-cdn.atlassian.com") ||
                q.absoluteString.starts(with: "https://www.stockvault.net/data")
            ) {
            DispatchQueue.global().async {
                let imgData = TestHelpers.data(fromImage: "photo-test")
                completionHandler(imgData, self.successResponse(url: request.url!), nil)
            }
        } else {
            dispatchFailure(completionHandler, request)
        }
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        guard let query = request.url?.absoluteString, let storedInfo = storedData[query] else {
            handleImageFetch(completionHandler, request)
            return StubDataTask()
        }
        
        if let i = findInfoForNonNilRequest(storedInfo, request) {
            dispatchSuccess(storedInfo[i], completionHandler, request)
        } else if let i = findInfoForNilRequest(storedInfo, request) {
            dispatchSuccess(storedInfo[i], completionHandler, request)
        } else {
            dispatchFailure(completionHandler, request)
        }
        
        return StubDataTask()
    }
    
    func successResponse(url: URL) -> HTTPURLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    func failedResponse(url: URL) -> HTTPURLResponse {
        return HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
    }
    
    private func injectable(from responseResourceName: String?) -> String? {
        guard let responseResourceName = responseResourceName,
            let data = TestHelpers.data(fromResourceName: responseResourceName),
            let responseData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
                return nil
        }
        return String(data: responseData, encoding: String.Encoding.utf8)!
    }
}


private class StubDataTask: URLSessionDataTask {
    override func resume() {}
}

private class StubUploadTask: URLSessionUploadTask {
    override func resume() {}
}

private final class TestHelpers {
    
    private struct TestHelpersErrorConstants {
        static let invalidResource = "Invalid file path for fixture"
        static let invalidData = "No data found"
        static let malformedJSON = "JSON was malformed"
        static let invalidJSON = "JSON was malformed"
    }
    
    enum ResourceType: String {
        case json
        case plist
        case jpeg
    }
    
    private static func path(for resource: String, ofType type: String) -> String {
        
        guard let filePath = Bundle.main.path(forResource: resource, ofType: type) else {
            fatalError(TestHelpersErrorConstants.invalidResource)
        }
        
        return filePath
    }
    
    static func data(fromResourceName resource: String, ofType type: ResourceType = .plist) -> Data? {
        
        guard resource != "-" else {
            return nil
        }
        
        guard let data = NSData(contentsOfFile: path(for: resource, ofType: type.rawValue)) as Data? else {
            fatalError(TestHelpersErrorConstants.invalidData)
        }
        
        return data
    }
    
    static func data(fromImage resource: String, ofType type: ResourceType = .jpeg) -> Data {
        
        guard let data = NSData(contentsOfFile: path(for: resource, ofType: type.rawValue)) as Data? else {
            fatalError(TestHelpersErrorConstants.invalidData)
        }
        
        return data
    }
}
