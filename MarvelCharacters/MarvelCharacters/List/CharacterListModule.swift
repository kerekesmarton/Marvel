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

public class CharacterListModule: TabModule {
    public var tabIdentifier: String
    public var tab: Int
    public init(id: String, tab: Int) {
        tabIdentifier = id
        self.tab = tab
    }
    
    public func setup(title: String, image: String?, config: Configurable) -> (controller: UIViewController, router: Routing) {
        
        let vc = UIStoryboard.viewController(with: "CharacterListViewController",
                                             storyboard: "Characters",
                                             bundle: Bundle(for: CharacterListViewController.self)) as! CharacterListViewController
        let navigation = createNavigation(with: title, imageResource: image, tag: tab)
        let router = CharacterListRouter(host: navigation, context: vc)
        let fetcher = CharacterListFetcher(service: NetworkDataServiceFactory.GetCharacterListDataService(config))
        let presenter = CharacterListPresenter(charecterListFetcher: fetcher, router: router)
        
        presenter.output = vc
        vc.presenter = presenter
        
        return (navigation, router)
    }
    
    
    public func setup(host: UINavigationController, config: Configurable) -> (router: Routing, viewController: UIViewController) {
    
        let vc = UIStoryboard.viewController(with: "CharacterListViewController",
                                             storyboard: "Profile",
                                             bundle: Bundle(for: CharacterListViewController.self)) as! CharacterListViewController
        let router = CharacterListRouter(host: host, context: vc)
        let fetcher = CharacterListFetcher(service: NetworkDataServiceFactory.GetCharacterListDataService(config))
        let presenter = CharacterListPresenter(charecterListFetcher: fetcher, router: router)
        
        presenter.output = vc
        vc.presenter = presenter
        
        return (router, vc)
    }
}
