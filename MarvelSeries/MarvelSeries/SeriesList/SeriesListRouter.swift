//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import UIKit
import IosCore
import Domain
import MarvelDomain

class SeriesListRouter: Routing, SeriesListRouting {
    
    init(host: UINavigationController?, context: UIViewController) {
        self.context = context
        self.host = host
    }
    
    func start() {
        guard let context = context else { return }
        host?.pushViewController(context, animated: true)
    }
    
    func routeSeries(_ story: Entities.Series) {
        
    }
    
    weak var host: UINavigationController?
}

extension SeriesListRouter: ScrollableChildRouter {
    func scrollToTop() {
        if let scrollView = context?.view as? UICollectionView, scrollView.contentSize.height > 0 {
            scrollView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

