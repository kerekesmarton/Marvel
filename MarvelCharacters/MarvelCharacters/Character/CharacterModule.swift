//
//  CharacterModule.swift
//  MarvelCharacters
//
//  Created by Marton Kerekes on 06/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import Data
import Presentation
import IosCore
import MarvelDomain
import MarvelData


public class CharacterModule: Module {
    
    public init() {}
    
    public func setup(character: Entities.Character, host: UINavigationController, config: Configurable) -> (router: Routing, viewController: UIViewController) {
        
        let vc = UIStoryboard.viewController(with: "CharacterViewController",
                                             storyboard: "Characters",
                                             bundle: Bundle(for: CharacterViewController.self)) as! CharacterViewController
        let router = CharacterRouter(navigation: host, context: vc, presentationHost: nil)
        let presenter = CharacterPresenter(router: router, character: character)
        
        presenter.output = vc
        vc.presenter = presenter
        
        return (router, vc)
    }
    
    public func setup(character: Entities.Character, presentationHost: UIViewController, config: Configurable) -> (router: Routing, viewController: UIViewController) {
        
        let vc = UIStoryboard.viewController(with: "CharacterViewController",
                                             storyboard: "Characters",
                                             bundle: Bundle(for: CharacterViewController.self)) as! CharacterViewController
        let nav = createNavigation(with: "", imageResource: nil, tag: 0)
        let router = CharacterRouter(navigation: nav, context: vc, presentationHost: presentationHost)
        let presenter = CharacterPresenter(router: router, character: character)
        
        presenter.output = vc
        vc.presenter = presenter
        
        return (router, nav)
    }
}
