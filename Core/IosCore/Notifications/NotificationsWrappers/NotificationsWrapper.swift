//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Presentation

public class NotificationsWrapper: NSObject, NotificationServices {
    
    public static let shared = NotificationsWrapper()
    private override init(){
        super.init()
    }
    
    private var presenter: AppPresenting?
    
    public func requestAccess() {
        
    }
    
    public func launch(with presenter: AppPresenting) {
        
    }
    
    public func registrationSucceeded(forChannelID channelID: String, deviceToken: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "channelIDUpdated"),
                                        object: self,
                                        userInfo:nil)
    }
    
    public func receivedDeepLink(_ url: URL, completionHandler: @escaping () -> Void) {
        presenter?.link(with: DeepLinkOption<URL>.payload(url))
        completionHandler()
    }
}
