//
//  Profile
//
//  Copyright © 2019 mkerekes. All rights reserved.
//

import Foundation
import IosCore
import Presentation
import Domain
import Data

public final class CredentialsModule: LoginModulable, Module {
    
    public init() {}
    
    public func setup(config: Configurable, didFinishAuth: @escaping UserDidFinishAuth) -> (controller: UIViewController, router: Routing) {
        
        let controller = UIStoryboard.viewController(with: String(describing: LoginViewController.self),
                                                     storyboard: "Session",
                                                     bundle: Bundle(for: LoginViewController.self)) as! LoginViewController
        
        let navigationController = ClearNavigationController(rootViewController: controller)
        let router = LoginRouter(nav: navigationController, context: nil, didFinishAuth: didFinishAuth)
        let presenter = LoginPresenter(userRepository: config.userProfileStore,
                                       router: router,
                                       config: config)
        presenter.view = controller
        controller.presenter = presenter
        
        return (navigationController, router)
        
    }
    
}

