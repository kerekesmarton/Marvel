//
//  CharacterListModule.swift
//  Characters
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import Data
import Presentation
import IosCore


public class CharacterListModule: Module {
    
    public init() {}
    
    public func setup(host: UINavigationController, config: Configurable) -> (router: Routing, viewController: UIViewController) {
    
        let vc = UIStoryboard.viewController(with: "CharacterListViewController",
                                             storyboard: "Profile",
                                             bundle: Bundle(for: CharacterListViewController.self)) as! CharacterListViewController
        let router = CharacterListRouter(host: host, context: vc)
        let presenter = CharacterListPresenter(router: router)
        
        presenter.output = vc
        vc.presenter = presenter
        
        return (router, vc)
    }
}
