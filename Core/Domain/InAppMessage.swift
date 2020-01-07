//
//  Domain
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Additions

public enum InAppMessage {
    case error(ServiceError?)
    case message(String)
    case link(String?, URL?)
    
    public var providedLink: URL? {
        switch self {
        case .link(_, let url):
            return url
        default:
            return nil
        }
    }
    
    public var isDeepLink: Bool {
        switch self {
        case .link(_, _):
            return true
        default:
            return false
        }
    }
    
    public var text: String? {
        switch self {
        case .error(let serviceError):
            return serviceError?.message
        case .message(let text):
            return text
        case .link(let text, _):
            return text
        }
    }
        
    public var shouldShow: Bool {
        if let text = text, text.count > 0 {            
            if (TestHelper.isTesting || TestHelper.isUITesting) && isDeepLink {
               return true
            } else if TestHelper.isTesting || TestHelper.isUITesting {
                return false
            } else {
                return true
            }
        }
        
        return false
    }
}
