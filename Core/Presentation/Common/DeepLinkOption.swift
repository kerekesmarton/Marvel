///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain

public struct PushNotification: Codable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    public var data: DeepLinkData
    
}

public struct DeepLinkData: Codable {
    
    enum CodingKeys: String, CodingKey {
        case pinpoint
        case jsonBody
    }
    
    var pinpoint: [String: String]
    var jsonBody: [String: String]
    public var linkValue: DeepLink? {
        guard let value = pinpoint["deeplink"], let notificationId = jsonBody["notificationId"]  else { return nil }
        return DeepLink(value: value, notificationId: notificationId)
    }
}

public struct DeepLink {
    public var value: String
    public var notificationId: String
}

public enum DeepLinkOption<T> {
    case activity(NSUserActivity)
    case payload(T)
    case deeplink(DeepLink)
    
    public var extractedURL: URL? {        
        switch self {
        case .activity(_):
            return nil
            
        case .payload(let payload):
            guard let payload = payload as? String else { return nil }
            return extractUrlFromDeepLink(deepLinkValue: payload)
            
        case .deeplink(let deeplink):
            return extractUrlFromDeepLink(deepLinkValue: deeplink.value)
        }
        
    }
    
    public var payload: T? {
        switch self {
        case .payload(let payload):
            return payload
        default:
            return nil
        }
    }
    
    public enum DeepLinkDestination: String {
        case post = "posts"
        case profile = "profiles"
        case unknown = "unknown"
    }
    
    public var notificationId: String? {
        switch self {
        case .activity(_):
            return nil
        case .payload(_):
            return nil
        case .deeplink(let deeplink):
            return deeplink.notificationId
        }
        
    }
    
    public var social: String? {
        guard let deepLinkUrlStr = self.extractedURL?.absoluteString,
            let id = deepLinkUrlStr.components(separatedBy: "/")[safe: 0] else { return  nil }
        return id
    }
    
    public var destination: DeepLinkDestination {
        guard let deepLinkUrlStr = self.extractedURL?.absoluteString,
            let destination = deepLinkUrlStr.components(separatedBy: "/")[safe: 1],
            let result = DeepLinkOption<T>.DeepLinkDestination(rawValue: destination) else { return .unknown }
        return result
    }
    
    public var destinationId: String? {
        guard let deepLinkUrlStr = self.extractedURL?.absoluteString,
            let id = deepLinkUrlStr.components(separatedBy: "/")[safe: 2] else { return  nil }
        return id
    }
    
    public func extractUrlFromDeepLink(deepLinkValue: String) -> URL? {
        return URL(string: "some.com")
    }
}
