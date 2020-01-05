//
//  CharacterListRouter.swift
//  Characters
//
//  Created by Marton Kerekes on 04/01/2020.
//  Copyright © 2020 Marton Kerekes. All rights reserved.
//

import Foundation
import IosCore
import UIKit

class CharacterListRouter: Routing, CharacterListRouting {
    
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
    
    weak var context: UIViewController?
    weak var host: UINavigationController?
    
}
