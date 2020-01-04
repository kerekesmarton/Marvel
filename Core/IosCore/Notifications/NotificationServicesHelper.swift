///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import UIKit
import Presentation
import Domain
import Additions

public class NotificationServicesHelper {
    var appPresenter: AppPresenting!
    
    public init(appPresenter: AppPresenting) {
        self.appPresenter = appPresenter
    }
    
    public func extractParams(from launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> DeepLink? {
        
        if TestHelper.isUITesting {
            if let info = ProcessInfo().environment[UIApplication.LaunchOptionsKey.remoteNotification.rawValue] {
                guard let data = info.data(using: .utf8),
                    let pushNotification = try? JSONDecoder().decode(PushNotification.self, from: data),
                    let linkValue =  pushNotification.data.linkValue  else { return nil }
                
                return linkValue
            } else {
                return nil
            }
        } else {
            guard let json = launchOptions?[.remoteNotification] as? [String: AnyObject],
                let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                let pushNotification = try? JSONDecoder().decode(PushNotification.self, from: data),
                let linkValue =  pushNotification.data.linkValue else { return nil }
            
            return linkValue
        }
    }
    
    public func forwardNotification(to presenter: AppPresenting, from launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        guard TestHelper.isUITesting else {
            return
        }
        
        guard let info = ProcessInfo().environment[UIApplication.LaunchOptionsKey.remoteNotification.rawValue] else {
            return
        }
        guard let data = info.data(using: .utf8) else {
            return
        }
        //#warning("update with decoded message")
        presenter.displayInApp(message: InAppMessage.message(data.base64EncodedString()), completion: { _ in () })
    }

    public func processOtherArguments(from launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
        for argument in launchOptions {
            switch (argument.key.rawValue, argument.value as? String) {
            case ("NoAnimations", "true"):
                UIView.setAnimationsEnabled(false)
            default:
                break
            }
        }
    }
}
