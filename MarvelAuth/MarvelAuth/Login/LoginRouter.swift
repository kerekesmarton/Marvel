//
//  Profile
//
//  Copyright © 2019 mkerekes. All rights reserved.
//

import Domain
import Presentation
import Data
import IosCore

class LoginRouter: LoginRouting, Routing, ErrorRouting {
    
    var parent: Routing?
    weak var navigation: UINavigationController?
    var context: UIViewController?
    let didFinishAuth: UserDidFinishAuth
    
    init(nav: UINavigationController, context: UIViewController?, didFinishAuth: @escaping UserDidFinishAuth) {
        navigation = nav
        self.context = context
        self.didFinishAuth = didFinishAuth
    }
    
    func start() {}
    
    func finish() {
        didFinishAuth()
    }
    
    func routeToSignUp() {
        
    }
    
    func route(title: String?, message: String?,
               buttonTitle: String?, action routingAction: @escaping UserDidFinishAuth) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (action) in
            routingAction()
        }))
        
        DispatchQueue.main.async {
            self.context?.present(alert, animated: true)
        }
    }
    
    func present(controller: UIViewController) {
        navigation?.present(controller, animated: true)
    }
}
