//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import Domain
import Data
import Presentation
import IosCore

public class SeriesListModule: SeriesListModuleable, TabModule {
    public var tabIdentifier: String
    public var tab: Int
    public init(id: String, tab: Int) {
        tabIdentifier = id
        self.tab = tab
    }
    
    
    public func setup(type: SeriesListType, config: Configurable) -> (router: Routing, viewController: UIViewController) {
    
        let vc = viewController()
        let router = SeriesListRouter(host: nil, context: vc)
        let fetcher = SeriesListFetcher(service: NetworkDataServiceFactory.GetSeriesListDataService(config))
        let presenter = SeriesListPresenter(type: type, fetcher: fetcher, router: router)
        
        presenter.output = vc
        vc.presenter = presenter
        
        return (router, vc)
    }
    
    public func setup(title: String, image: String?, config: Configurable) -> (controller: UIViewController, router: Routing) {
        
        let navigation = createNavigation(with: title, imageResource: image, tag: tab)
        let vc = viewController()
        let router = SeriesListRouter(host: navigation, context: vc)
        let fetcher = SeriesListFetcher(service: NetworkDataServiceFactory.GetSeriesListDataService(config))
        let presenter = SeriesListPresenter(type: .all, fetcher: fetcher, router: router)
        
        presenter.output = vc
        vc.presenter = presenter
        return (navigation, router)
    }
    
    private func viewController() -> SeriesListViewController {
        return UIStoryboard.viewController(with: "SeriesListViewController",
                                           storyboard: "Series",
                                           bundle: Bundle(for: SeriesListViewController.self)) as! SeriesListViewController
    }
}
