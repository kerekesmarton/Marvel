///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Presentation

public class SettingsModule: Module {
    
    public init() {}
    
    public func setup(host: UINavigationController, config: Configurable) -> (router: Routing, viewController: UIViewController) {
        
        let vc = UIStoryboard.viewController(with: "SettingsViewController",
                                             storyboard: "UI",
                                             bundle: Bundle(for: SettingsViewController.self)) as! SettingsViewController
        let router = SettingsRouter(host: host, context: vc)
        let presenter = SettingsPresenter(router: router)
        
        presenter.output = vc
        vc.presenter = presenter
        
        return (router, vc)
    }
}
