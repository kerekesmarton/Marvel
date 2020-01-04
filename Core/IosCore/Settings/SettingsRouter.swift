///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Presentation
import Domain

class SettingsRouter: Routing, SettingsRouting {
    
    init(host: UINavigationController, context: UIViewController) {
        self.context = context
        self.host = host
    }
    
    func start() {
        guard let context = context else { return }
        host?.pushViewController(context, animated: true)
    }
    
    weak var host: UINavigationController?
    
    func route(settings: Settings, animated: Bool) {
        switch settings {
        case .external:
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }
    }
    
    func route<T>(deepLink: DeepLinkOption<T>, stack: [UIViewController]) {
        guard case DeepLinkOption.payload(let payload) = deepLink, let settings = payload as? Settings else {
            return
        }
        
        switch settings {
        case .external:
            ()
        }
    }
}
