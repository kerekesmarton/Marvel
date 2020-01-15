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
import Domain

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
    
    weak var host: UINavigationController?
    
    func route(character: Entities.Character) {
        guard let context = context else { return }
        let module: CharacterModule = config.appModules.module()
        let result = module.setup(character: character, presentationHost: context, config: config)
        addChild(router: result.router)
        result.router.start()
    }
    
}
