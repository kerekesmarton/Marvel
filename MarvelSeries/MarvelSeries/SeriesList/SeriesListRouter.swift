//
//  Created by Marton Kerekes on 07/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import UIKit
import IosCore
import Domain

class SeriesListRouter: Routing, SeriesListRouting {
    
    init(host: UINavigationController, context: UIViewController) {
        self.context = context
        self.host = host
    }
    
    func start() {
        guard let context = context else { return }
        host?.pushViewController(context, animated: true)
    }
    
    var parent: Routing?
    
    func present(controller: UIViewController) {
        context?.present(controller, animated: true, completion: {
            
        })
    }
    
    func routeSeries(_ story: Entities.Series) {
        
    }
    
    weak var context: UIViewController?
    weak var host: UINavigationController?
    
}
