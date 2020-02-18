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
import MarvelDomain
import MarvelData

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
        let fetcher = CharacterListFetcher(factory: CharacterListServiceFactoryProvider(config: config))
        let presenter = CharacterListPresenter(charecterListFetcher: fetcher, router: router)
        
        presenter.output = vc
        vc.presenter = presenter
        vc.searchController = UISearchController(searchResultsController: nil)
        
        return (navigation, router)
    }
    
    
    public func setup(host: UINavigationController, config: Configurable) -> (router: Routing, viewController: UIViewController) {
    
        let vc = UIStoryboard.viewController(with: "CharacterListViewController",
                                             storyboard: "Profile",
                                             bundle: Bundle(for: CharacterListViewController.self)) as! CharacterListViewController
        let router = CharacterListRouter(host: host, context: vc)
        let fetcher = CharacterListFetcher(factory: CharacterListServiceFactoryProvider(config: config))
        let presenter = CharacterListPresenter(charecterListFetcher: fetcher, router: router)
        
        presenter.output = vc
        vc.presenter = presenter
        
        return (router, vc)
    }
}

class CharacterListServiceFactoryProvider: CharacterListServiceFactory {
    
    let config: Configurable
    init(config: Configurable) {
        self.config = config
    }
    
    func makeService() -> SpecialisedDataService {
        return NetworkDataServiceFactory.GetCharacterListDataService(config )
    }
}
